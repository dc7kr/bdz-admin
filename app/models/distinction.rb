class Distinction < ApplicationRecord
  belongs_to :orchestra
  belongs_to :member_account_booking, optional:true

  def gen_invoice
    invoice = CorikaInvoices::Invoice.new
    invoice.invoice_type="ehrungsrechnung"
    invoice.our_contact = "distinction"
    invoice.customer = orchestra.to_customer
    invoiceNumber = "E-"+Time.now.strftime("%Y%m%d-")+invoice.customer.customer_id
    invoice.number = invoiceNumber

    # Brutto Rechnung 
    invoice.tax_type = "B"
    invoice.taxrate = INVOICE_CONFIG.taxrate
    invoice.taxrate_reduced = INVOICE_CONFIG.taxrate_reduced

    invoice.considerItem(certificates,Prices.certificate,"Urkunden")
    invoice.considerItem(silver_needles,Prices.silverNeedle, 'Silbernadel')
    invoice.considerItem(gold_needles,Prices.goldenNeedle, 'Goldnadel')
    invoice.considerItem(honorletters,Prices.honorLetter, 'Ehrenbrief mit Urkundenmappe')
    invoice.considerItem(medals,Prices.medal, 'BDZ-Verdienstmedaille')
    invoice.considerItem(national_needles,Prices.nationalNeedle, 'BDZ-Bundesnadel')

    portoPrice = nil 

    if ( porto.nil? ) then
      portoPrice = Prices.distinctionPorto
    else
      portoPrice = porto
    end

    invoice.considerItem( 1, portoPrice , 'Porto und Verpackungskostenanteil')

    invoice
  end

  def has_booking? 
    not member_account_booking.nil?
  end

  def has_generated_invoice?
    not invoice_id.nil?
  end
end
