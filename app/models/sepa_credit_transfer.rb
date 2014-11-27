class SEPACreditTransfer 

  attr_accessor :end_to_end_id,:amount,:remittance_txt,:sequence_type,:customer,:amount

  def initialize(customer,amount)
    @customer = customer
    @amount = amount
  end

  def amount 
    @amount
  end

  def iban
    @customer.iban
  end

  def bic
    @customer.bic
  end

  def end_to_end_id(prefix)
    prefix+"_"+@customer.mglnr.to_s
  end
end
