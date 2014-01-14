class InvoiceItem
  attr_accessor :count, :price, :label

  def initialize(count,price,label)
    @count = count
    @price = price
    @label = label 
  end

end
