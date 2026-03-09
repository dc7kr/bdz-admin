class EventCard < ApplicationRecord
  # attr_accessible :title, :body
  validates :name, presence: true
  validates :email, presence: true
  validates :email, email_format: true

  validates_with EventCardValidator

  validates :iban, iban:true, if: :direct_debit?
  validates :bic, bic: true, if: :direct_debit?

  include FestivalTicketHelper

  scope :current_festival, -> { where("festival_year = ?", BDZ_SETTINGS["config"]["festival_year"]) }

  scope :not_invoiced, -> { where(invoiced: 0) }

  def self.search(search)
    if search
      where("name like ? or id = ?", "%#{search}%", search)
    else
      where("1")
    end
  end

  def ordered_cards
    ordered = []
    prices = BDZ_SETTINGS["festival_prices"]

    if nr_fest.positive?
      c = OrderedCard.new(nr_fest, prices["ticket"], "fest")
      ordered << c
    end

    if nr_fest_erm.positive?
      c = OrderedCard.new(nr_fest_erm, prices["ticket_red"], "fest_erm")
      ordered << c
    end

    if nr_fest_bdz.positive?
      c = OrderedCard.new(nr_fest_bdz, prices["fest_bdz"], "fest_bdz")
      ordered << c
    end

    if nr_fest_bdz_erm.positive?
      c = OrderedCard.new(nr_fest_bdz_erm, prices["fest_bdz_erm"], "fest_bdz_erm")
      ordered << c
    end

    if nr_do.positive?
      c = OrderedCard.new(nr_do, prices["tageskarte"], "do")
      ordered << c
    end

    if nr_do_erm.positive?
      c = OrderedCard.new(nr_do_erm, prices["tageskarte_erm"], "do_erm")
      ordered << c
    end

    if nr_fr.positive?
      c = OrderedCard.new(nr_fr, prices["tageskarte"], "fr")
      ordered << c
    end

    if nr_fr_erm.positive?
      c = OrderedCard.new(nr_fr_erm, prices["tageskarte_erm"], "fr_erm")
      ordered << c
    end

    if nr_sa.positive?
      c = OrderedCard.new(nr_sa, prices["tageskarte"], "sa")
      ordered << c
    end

    if nr_sa_erm.positive?
      c = OrderedCard.new(nr_sa_erm, prices["tageskarte_erm"], "sa_erm")
      ordered << c
    end

    if nr_concert_so.positive?
      c = OrderedCard.new(nr_concert_so, prices["concert"], "concert_so")
      ordered << c
    end

    if nr_concert_so_erm.positive?
      c = OrderedCard.new(nr_concert_so_erm, prices["concert_erm"], "concert_so_erm")
      ordered << c
    end

    ordered
  end

  def total_card_count
    nr_fest + nr_fest_bdz + nr_do + nr_fr + nr_sa + nr_do_erm + nr_fr_erm + nr_sa_erm + nr_fest_erm + nr_fest_bdz_erm + nr_concert_so + nr_concert_so_erm
  end

  def sum
    prices = BDZ_SETTINGS["festival_prices"]
    sum = 0
    sum += nr_fest * prices["ticket"]
    sum += nr_fest_erm * prices["ticket_red"]
    sum += nr_fest_bdz * prices["fest_bdz"]
    sum += nr_fest_bdz_erm * prices["fest_bdz_erm"]
    sum += (nr_do + nr_fr + nr_sa) * prices["tageskarte"]
    sum += (nr_do_erm + nr_fr_erm + nr_sa_erm) * prices["tageskarte_erm"]
    sum += nr_concert_so * prices["concert"]
    sum + (nr_concert_so_erm * prices["concert_erm"])
  end

  def invoice
    if has_invoice?
      CorikaInvoices::Invoice.find(invoice_id)
    else
      nil
    end
  end

  def to_invoice
    if has_invoice?
      invoice = CorikaInvoices::Invoice.find(invoice_id)
      if invoice.final?
        return invoice
      end
    else
      ts = Time.zone.now.strftime "%Y%m%d"
      renr = ts + "-EC#{id}"
      year = Time.zone.now.year if year.nil?

      invoice = CorikaInvoices::Invoice.new
      invoice.invoice_date = Time.zone.now
      invoice.booking_year = year
      invoice.template_subdir = "ef"

      # With tax
      invoice.tax_mode = "S"
      invoice.number_suffix = renr

      c_hash = INVOICE_CONTACT_HASH["festival_gs"]
      contact = CorikaInvoices::Contact.new(c_hash)
      invoice.contact = contact
    end

    invoice.template = "event_card.#{preferred_lang}"
    invoice.locale = preferred_lang
    invoice.payment_method = payment_method

    invoice.customer = to_customer

    invoice.invoice_items.clear()

    prices = BDZ_SETTINGS["festival_prices"]

    item = consider_regular_tickets(invoice, nr_fest)
    item = consider_reduced_tickets(invoice, nr_fest_erm)

    #invoice.consider_item_gross(nr_fest_bdz, prices["fest_bdz"], I18n.t("event_card.fest_bdz"))
    #invoice.consider_item_gross(nr_fest_bdz_erm, prices["fest_bdz_erm"], I18n.t("event_card.fest_bdz_erm"))
    invoice.consider_item_gross(nr_do, prices["tageskarte"], I18n.t("event_card.do"), tax_rate:7)
    invoice.consider_item_gross(nr_fr, prices["tageskarte"], I18n.t("event_card.fr"), tax_rate:7)
    invoice.consider_item_gross(nr_sa, prices["tageskarte"], I18n.t("event_card.sa"), tax_rate:7)
    invoice.consider_item_gross(nr_do_erm, prices["tageskarte_erm"], I18n.t("event_card.do_erm"),tax_rate:7)
    invoice.consider_item_gross(nr_fr_erm, prices["tageskarte_erm"], I18n.t("event_card.fr_erm"),tax_rate:7)
    invoice.consider_item_gross(nr_sa_erm, prices["tageskarte_erm"], I18n.t("event_card.sa_erm"),tax_rate:7)
    invoice.consider_item_gross(nr_concert_so, prices["concert"], I18n.t("event_card.concert_so"),tax_rate:7)
    invoice.consider_item_gross(nr_concert_so_erm, prices["concert_erm"], I18n.t("event_card.concert_so_erm"),tax_rate:7)

    invoice
  end

  def has_email?
    !email.nil?
  end

  def to_customer
    cust = CorikaInvoices::Customer.new
    cust.customer_id = id
    cust.last_name = name
    cust.salutation = ""

    ef_year = BDZ_SETTINGS["config"]["festival_year"]

    if street.present?
      cust.zip = zip
      cust.city = city
      cust.street = street
      cust.country_code = country_code
    else
      cust.street = "- via mail -"
      cust.city = " "
      cust.zip = " "
      cust.country_code = " "
    end

    cust.country_code = country_code

    # cust.preferred_lang = preferred_lang
    if cust.country_code.nil?
      cust.country_code = "DE" if email.end_with?(".de") || email.end_with?(".at")
    end

    if direct_debit?
      cust.direct_debit = 1
      cust.iban = iban
      cust.bic = bic
      cust.account_owner = account_owner
      cust.mandate_id = "EF#{ef_year}CARD#{id}"
      cust.sig_date = Time.now
    end

    cust
  end

  def to_locale
    if preferred_lang  == "de"
      "de"
    else
      "en"
    end
  end

  def payment_text
    "#{I18n.t("event_card", count: 1)} #{id}"
  end


  def event_class
    # ContactEvent
    nil
  end

  def to_param
    checkout_reference
  end

  def has_invoice?
    not invoice_id.nil?
  end

  def is_online_payment?
    return payment_method == "credit_card"
  end

  def direct_debit?
    return payment_method == "direct_debit"
  end

  def update_invoice
    return  to_invoice unless has_invoice?

    i = invoice
    ef_year = BDZ_SETTINGS["config"]["festival_year"]

    i.payment_method = payment_method

    if direct_debit?
      i.customer.direct_debit = 1
      i.customer.iban = iban
      i.customer.bic = bic
      i.customer.account_owner = account_owner
      i.customer.mandate_id = "EF#{ef_year}CARD#{id}"
      i.customer.sig_date = Time.now
    end

    i
  end
end
