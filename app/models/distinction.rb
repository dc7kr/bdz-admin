class Distinction < ApplicationRecord
  belongs_to :orchestra
  belongs_to :member_account_booking, optional: true

  def gen_invoice
    invoice = CorikaInvoices::Invoice.new
    invoice.template = "ehrungsrechnung"
    invoice.template_subdir = "bdz"
    invoice.invoice_date = Time.zone.now

    invoice.customer = orchestra.to_customer

    # invoice.our_contact = "distinction"

    invoice.booking_year = Time.now.year
    invoice.invoice_date = Time.now

    c_hash = INVOICE_CONTACT_HASH["distinction"]
    contact = CorikaInvoices::Contact.new(c_hash)
    invoice.contact = contact

    invoiceNumber = "E-#{Time.zone.now.strftime('%Y%m%d-')}#{invoice.customer.customer_id}"
    invoice.number = invoiceNumber

    # Brutto Rechnung
    invoice.tax_mode = "E"

    invoice.consider_item(certificates, Prices.certificate, "Urkunden")
    invoice.consider_item(silver_needles, Prices.silverNeedle, "Silbernadel")
    invoice.consider_item(gold_needles, Prices.goldenNeedle, "Goldnadel")
    invoice.consider_item(honorletters, Prices.honorLetter, "Ehrenbrief mit Urkundenmappe")
    invoice.consider_item(medals, Prices.medal, "BDZ-Verdienstmedaille")
    invoice.consider_item(national_needles, Prices.nationalNeedle, "BDZ-Bundesnadel")

    portoPrice = if porto.nil?
                   Prices.distinctionPorto
    else
                   porto
    end

    item = invoice.consider_item(1, portoPrice, "Porto und Verpackungskostenanteil")
    item.tax_rate = 0

    invoice
  end

  def has_booking?
    !member_account_booking.nil?
  end

  def has_generated_invoice?
    !invoice_id.nil?
  end
end
