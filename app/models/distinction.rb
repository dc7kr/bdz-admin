class Distinction < ActiveRecord::Base
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


  def gen_invoice(number)
    @invoice = Invoice.new(number)
    @invoice.customer = orchestra.to_customer
    @invoice << InvoiceItem.new(certificates,Prices.certificate,"Urkunden")
    @invoice << InvoiceItem.new(silver_needles,Prices.silverNeedle, 'Silbernadel')
    @invoice << InvoiceItem.new(gold_needles,Prices.goldenNeedle, 'Goldnadel')
    @invoice << InvoiceItem.new(honorletters,Prices.honorLetter, 'Ehrenbrief mit Urkundenmappe')
    @invoice << InvoiceItem.new(medals,Prices.medal, 'BDZ-Verdienstmedaille')
    @invoice << InvoiceItem.new(national_needles,Prices.nationalNeedle, 'BDZ-Bundesnadel')

    portoPrice = nil 

    if ( porto.nil? ) then
      portoPrice = Prices.distinctionPorto
    else
      portoPrice = porto
    end

    @invoice << InvoiceItem.new( 1, portoPrice , 'Porto und Verpackungskostenanteil')

    @invoice
  end
end
