module InvoiceHelper
  def self.calcSum(sheet)
    tariff = BDZ_SETTINGS["tariff"]
    childSum = tariff["children"] * sheet.children
    teensSum = tariff["teens"] * sheet.teens
    youthSum = tariff["youth"] * sheet.youth
    adultSum = tariff["adult"] * sheet.adult
    [ childSum, teensSum, youthSum, adultSum ]
  end

  def consider_item_gross(invoice, count, price, label, unit_code: "C62", tax_rate: 7)
    if  not count.nil? and count > 0
      item = CorikaInvoices::InvoiceItem.create_gross(count, price, label, unit_code: unit_code, tax_rate: tax_rate)
      invoice << item
    end
  end
end
