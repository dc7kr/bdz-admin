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
    if @customer.is_direct_debit? then
      @customer.iban
    else
      nil
    end
  end

  def bic
    if @customer.is_direct_debit? then
      @customer.bic
    else
      nil
    end
  end

  def end_to_end_id(prefix)
    prefix+"_"+@customer.mglnr.to_s
  end
end
