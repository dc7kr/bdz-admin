class FestivalExhibitor < Invoiceable
  scope :current_festival, -> { where(year: BDZ_SETTINGS["config"]["festival_year"]) }

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact

  def gen_invoice

    if invoice_id.present?
      return CorikaInvoices::Invoice.find(invoice_id)
    end

    prices = BDZ_SETTINGS["festival_prices"]

    ts = Time.zone.now.strftime "%Y%m%d"
    invoice_nr = ts + "-EXH-#{id}"

    invoice = CorikaInvoices::Invoice.new
    invoice.booking_year = Time.now.year
    invoice.invoice_date = Time.now.to_date
    invoice.number_suffix = invoice_nr
    invoice.template_subdir = "ef"

    c_hash = INVOICE_CONTACT_HASH["festival_gs"]

    contact = CorikaInvoices::Contact.new(c_hash)
    invoice.contact = contact

    invoice.customer = to_customer

    if INVOICE_CONFIG.default_tax_mode == "E"
      # tax exempt
      invoice.tax_mode = "E"
      invoice.exemption_reason = I18n.t("invoice.exempt_reason")
    else
      invoice.tax_mode = "S"
    end

    invoice.template = "exhibitor.de"
    invoice.locale = :de

    #price = nil
    #if not special_amount.nil? and special_amount > 0
    #    price=special_amount
    #else
    #    price=prices["exhibitors"][tariff]
    #end
    if special_tariff==1
      invoice.consider_item(1, special_amount, I18n.t("festival_exhibitor.special_tariff"), tax_rate: 19)
    else
      amount = prices["exhibitors"]["pack_#{tariff}"]
      invoice.consider_item(1, amount, "#{I18n.t("festival_exhibitor.tariff")} #{tariff}",tax_rate: 19)
    end

    if rollups.present? and rollups > 0
      invoice.consider_item(rollups, prices["exhibitors"]["rollup"], I18n.t("festival_exhibitor.rollup"), tax_rate: 19)
    end

    if advert_type.present? and advert_type > 0
      invoice.consider_item(1, prices["exhibitors"]["advert_#{advert_type}"], I18n.t("festival_exhibitors.advert_#{advert_type}"), tax_rate: 19)
    end

    if extra_tables.present? and extra_tables > 0
      invoice.consider_item(extra_tables, prices["exhibitors"]["extra_tables"], I18n.t("festival_exhibitor.extra_tables"), tax_rate: 19)
    end

    invoice
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

    if not contact.present?
      Rails.logger.error("Contact is nil in exhibitor #{id}")
      cust.last_name = "INCONSISTENT"
      cust.company = "INCONSISTENT"
      return cust
    end

    cust.company = contact.company
    cust.salutation = contact.salutation
    cust.first_name = contact.first_name
    cust.last_name = contact.last_name
    cust.street = contact.street
    cust.zip = contact.zip
    cust.city = contact.city
    cust.country_code = contact.country_code
    cust.email = contact.email

    cust
  end
end
