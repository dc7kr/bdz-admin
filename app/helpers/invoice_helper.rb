module InvoiceHelper
  def self.calcSum(sheet)
    tariff = BDZ_SETTINGS['tariff']
    childSum = tariff['children'] * sheet.children
    teensSum = tariff['teens'] * sheet.teens
    youthSum = tariff['youth'] * sheet.youth
    adultSum = tariff['adult'] * sheet.adult
    [childSum, teensSum, youthSum, adultSum]
  end
end
