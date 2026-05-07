class FestivalApplication < Invoiceable
  include CountryHelper
  include InvoiceHelper

  include FestivalTicketHelper

  # attr_accessible :conductor, :contact_person, :equipment, :country_code, :num_players, :orch_name, :orchestra, :special_cast, :group_type,:permission,:festival_concert_id, :visitor_type, :rehearsal_time, :stage_time, :payment_status, :tickets, :tickets_red, :bdz_tickets_red, :bdz_tickets, :amount, :soloist_tickets, :contact_phone
  has_many :festival_pieces
  has_many :festival_application_attachments
  has_one :event_meal, foreign_key: "participant_id"
  has_one :contact_person

  has_one_attached :stage_plan
  has_one_attached :player_list

  accepts_nested_attributes_for :festival_pieces, allow_destroy: true

  validates :conductor, :num_players, :orch_name, presence: true

  belongs_to :orchestra, optional: true
  belongs_to :festival_concert, optional: true
  belongs_to :outdoor_concert, class_name: 'FestivalConcert', foreign_key: :outdoor_concert_id, optional: true

  scope :current_festival, -> { where(year: BDZ_SETTINGS["config"]["festival_year"]) }
  scope :permitted, -> { where(permission:  1) }
  scope :regular, -> { where("permission = 1 and visitor_type='R'") }

  scope :current_with_contacts, -> { FestivalApplication.current_festival.includes(:contact_person) }

  scope :no_meals, -> { left_outer_joins(:event_meal).where("event_meals.tln is NULL") }


  def t_country(locale = "de")
    translated_country(country_code, locale)
  end

  def self.search(search)
    if search
      where("orch_name like ? or id = ?", "%#{search}%", search)
    else
      where("1")
    end
  end

  def to_customer
    cust = CorikaInvoices::Customer.new
    cust.customer_id = id
    cust.direct_debit = false

    cust.id = id
    cust.entity = self

    # currently no DD
    cust.mandate_id = nil
    cust.iban = nil
    cust.bic = nil
    cust.sig_date = nil
    cust.email = contact_person.email
    cust.entity_type = self.class.name
    cust.entity_id = id

    cust.company = orch_name
    cust.salutation = contact_person.salutation
    cust.first_name = contact_person.first_name
    cust.last_name = contact_person.last_name
    cust.street = contact_person.street
    cust.zip = contact_person.zip
    cust.city = contact_person.city
    cust.country_code = contact_person.country_code

    cust
  end

  def has_fee_invoice?
    not fee_invoice_id.nil?
  end

  def has_ticket_invoice?
    not ticket_invoice_id.nil?
  end

  def prepare_invoice(inv_nr)
    germany = ISO3166::Country["DE"]
    austria = ISO3166::Country["AT"]

    inv = CorikaInvoices::Invoice.new
    inv.booking_year = Time.now.year
    inv.invoice_date = Time.now.to_date
    inv.number = inv_nr
    inv.template_subdir = "ef"

    c_hash = INVOICE_CONTACT_HASH["festival_gs"]

    contact = CorikaInvoices::Contact.new(c_hash)
    inv.contact = contact

    if INVOICE_CONFIG.default_tax_mode == "E"
      # tax exempt
      inv.tax_mode = "E"
      inv.exemption_reason = I18n.t("invoice.exempt_reason")
    else
      inv.tax_mode = "S"
    end

    if (contact_person.country_code == germany.alpha2) || (country_code == austria.alpha2)
      locale = :de
      inv.template = "festival.de"
    else
      locale = :en
      inv.template= "festival.en"
    end

    inv.locale = locale
    inv.customer = to_customer

    inv
  end

  def needs_fee_invoice?
    visitor_type == "R"
  end

  def get_fee_invoice
    if has_fee_invoice?
      i = CorikaInvoices::Invoice.find(fee_invoice_id)
      return i
    end

    if visitor_type != "R"
      return
    end

    prices = BDZ_SETTINGS["festival_prices"]

    ts = Time.zone.now.strftime "%Y%m%d"
    inv_nr = ts + "-F-#{id}"
    inv = prepare_invoice(inv_nr)

    if num_players < 30
      item = CorikaInvoices::InvoiceItem.create_gross(1, prices["reduced_fee"], I18n.t("festival_application.fee"), tax_rate: 7)
    else
      item = CorikaInvoices::InvoiceItem.create_gross(1, prices["fee"], I18n.t("festival_application.fee"), tax_rate: 7)
    end

    inv.invoice_items << item

    inv
  end

  def to_event_card
    ec = EventCard.new

    ec.nr_fest = tickets
    ec.nr_fest_erm =  tickets_red

    cust = to_customer

    ec.email =  cust.email

    if contact_person.country_code.present?
      preferred_lang = contact_person.country_code.downcase
      ec.preferred_lang = preferred_lang
      if preferred_lang != 'de'
         ec.preferred_lang = 'en'
      end
    end

    ec
  end

  def populate_invoice(inv)
    ec = to_event_card

    I18n.with_locale(ec.to_locale) do

      if not inv.present?
        inv = ec.to_invoice unless inv.present?
      else
        inv.invoice_items.clear
        ec.populate_invoice(inv)
      end

      inv.template = "participant_card.#{ec.preferred_lang}"

      inv.customer = to_customer

      if storno_invoice_id.present?
        inv_hash = storno_invoice.to_hash
        net = inv_hash[:invoice][:sum][:tax_basis]

        item = inv.add_item(1, net, I18n.t("festival_applications.paid_amount"), tax_rate: 19 )
        item.item_taxes.clear
        inv_hash[:invoice][:sum][:taxes].each do |tax|
          item.add_split_tax(tax[:rate],tax[:basis], I18n.t("common.vat"))
        end
      end
    end

    inv
  end

  def refresh_ticket_invoice
      i = CorikaInvoices::Invoice.find(ticket_invoice_id)

      return unless i.present?
      populate_invoice(i)

      i
  end

  def get_ticket_invoice
    if has_ticket_invoice?
      i = CorikaInvoices::Invoice.find(ticket_invoice_id)
      return i
    end

    inv = populate_invoice(nil)

    inv
  end

  def tickets_total
    sum=0
    sum+= tickets unless tickets.nil?
    sum+= tickets_red unless tickets_red.nil?
    sum
  end

  def ticket_warning?
    tickets_total > 0 and ticket_quota < 0.9
  end

  def payment_mismatch?
    ti = get_ticket_invoice

    if payment_status == "S"
      return false
    end

    return true unless ti.present?

    if ti.invoice_items[0].nil?
      return true
    end

    if ti.invoice_items[0].count != tickets
      return true
    end

    if ti.invoice_items.length > 1
      if ti.invoice_items[1].total < 0 
        return false
      end
      if ti.invoice_items[1].count != tickets_red
        return true
      end
    end

    false
  end

  def ticket_quota
    tickets_total*1.0/num_players
  end

  def to_param
    token
  end

  def to_hash
    result = Hash.new
    result["name"] = orch_name
    result["conductor"] = conductor
    result["group_type"] =  group_type

    result
  end
end
