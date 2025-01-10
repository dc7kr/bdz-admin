class SepaDirectDebit < SepaContactFacade
  attr_accessor :end_to_end_id, :amount, :remittance_txt, :sequence_type

  def initialize(customer, seq_type = 'RCUR')
    super(customer)

    seq_type = 'RCUR' if seq_type.nil?

    @sequence_type = seq_type
  end

  def iban
    @customer.iban
  end

  def bic
    @customer.bic
  end

  def mandate_id
    @customer.mandate_id
  end

  def sig_date
    @customer.sig_date
  end

  def end_to_end_id(prefix)
    prefix + '_' + @customer.id.to_s
  end
end
