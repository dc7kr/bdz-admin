class SepaCreditTransfer
  attr_accessor :end_to_end_id, :amount, :remittance_txt, :sequence_type, :customer, :amount

  def initialize(customer, amount)
    @customer = customer
    @amount = amount
  end

  attr_reader :amount

  def iban
    return unless @customer.is_direct_debit?

    @customer.iban
  end

  def bic
    return unless @customer.is_direct_debit?

    @customer.bic
  end

  def end_to_end_id(prefix)
    prefix + '_' + @customer.mglnr.to_s
  end
end
