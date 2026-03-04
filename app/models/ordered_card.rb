class OrderedCard
  attr_accessor :count, :key, :price

  def initialize(count, price, key)
    @count = count
    @key = key
    @price = price
  end

  def total
    if @count.nil? or @price.nil?
      0
    else
      @count * @price
    end
  end
end
