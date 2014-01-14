class SepaDirectDebit  < SepaContactFacade

  attr_accessor :end_to_end_id,:amount,:remittance_txt,:sequence_type

  def initialize(member, seq_type="RCUR")
    super(member)

    if (seq_type.nil?) then
      seq_type = "RCUR"
    end

    @sequence_type=seq_type
  end

  def iban
    @member.iban
  end

  def bic
    @member.bic
  end

  def mandate_id 
    "BDZBEITRAG"+@member.mglnr.to_s
  end

  def sig_date
    @member.sig_date
  end

  def end_to_end_id(prefix)
    prefix+"_"+@member.mglnr.to_s
  end
end
