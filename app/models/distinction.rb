class Distinction < ApplicationRecord
  belongs_to :orchestra
  belongs_to :member_account_booking

  def calcSum 
    sum = 0

    if ( silver_needles != nil ) then
      sum+=Prices.silverNeedle*silver_needles
    end

    if (gold_needles != nil ) then 
      sum+= Prices.goldenNeedle*gold_needles
    end
    if (honorletters != nil ) then 
      sum+=Prices.honorLetter*honorletters
    end
    if (certificates != nil) then
      sum+=Prices.certificate*certificates
    end
    if (national_needles != nil ) then
      sum+=Prices.nationalNeedle*national_needles
    end

    p = 0 
    if (porto == nil ) then
      p = Prices.distinctionPorto
    else 
      p = porto
    end
    sum+=p
  end


  def gen_invoice
    invoice = CorikaInvoices::Invoice.new
    invoice.invoice_type="ehrungsrechnung"
    invoice.our_contact = "distinction"
    invoice.customer = orchestra.to_customer
    invoiceNumber = "E-"+Time.now.strftime("%Y%m%d-")+invoice.customer.customer_id
    invoice.number = invoiceNumber
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
end
