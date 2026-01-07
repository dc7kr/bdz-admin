class FestivalExhibitor < ApplicationRecord
  scope :current_festival, -> { where(year: BDZ_SETTINGS["config"]["festival_year"]) }

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact
 

  def gen_invoice

    prices = BDZ_SETTINGS["festival_prices"]
    
    ts = Time.zone.now.strftime "%Y%m%d"
    invoice_nr = ts + "-EXH-#{id}"
    
    invoice = CorikaInvoices::Invoice.new
    invoice.booking_year = Time.now.year
    invoice.invoice_date = Time.now.to_date
    invoice.number = invoice_nr
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

    price = nil
    if not special_amount.nil? and special_amount > 0
        price=special_amount
    else
        price=prices["exhibitors"][tariff]
    end

    invoice.consider_item(1, price, "Ausstellergebühr BDZ eurofestival zupfmusik 2026", "C62", 19)

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


    cust.company = contact.company
    cust.salutation = contact.salutation
    cust.first_name = contact.first_name
    cust.last_name = contact.last_name
    cust.street = contact.street
    cust.zip = contact.zip
    cust.city = contact.city
    cust.country = contact.country_code

    cust
  end
end
