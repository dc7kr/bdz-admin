class Customer
  attr_accessor :id, :company, :name, :street, :zip, :city, :country, :iban, :bic, :salutation, :mandate_id, :entity, :sig_date,:account_owner,:preferred_lang

  def initialize(id,name, dd)
    @id=id
    @name=name
    @direct_debit = dd
  end

  def fullname
    name
  end

  def is_direct_debit?
    @direct_debit and not iban.nil?  and not bic.nil?
  end

  def customer_id 
    id
  end
end
