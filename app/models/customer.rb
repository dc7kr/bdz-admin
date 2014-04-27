class Customer
  attr_accessor :id, :company, :name, :street, :zip, :city, :country, :iban, :bic, :salutation, :mandate_id, :entity, :sig_date,:account_owner

  def initialize(id,name)
    @id=id
    @name=name
  end

  def fullname
    name
  end

  def self.fromEventCard(ec)
    Customer.new(ec.id,ec.name)
  end

  def is_direct_debit?
    not iban.nil?  and not bic.nil?
  end

  def customer_id 
    id
  end
end
