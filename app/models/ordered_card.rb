class OrderedCard
  attr_accessor :count, :key, :price


  def initialize(count, price, key)
    @count = count
    @key = key
    @price = price
  end

  def total 
    @count*@price
  end
end
