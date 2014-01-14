class Invoice
    attr_accessor :invoice_number
    attr_accessor :member

  def initialize(number)
    @invoice_number = number
    @items = Array.new
  end


  def items
    @items
  end

  def addItem(item)
    @items << item
  end

  def sum
    sum=0.0
    @items.each do  |item|
      sum+=item.count*item.price
    end
  end

  def <<(item)
    @items << item

  end

end
