class CreditTransferWriter < BankTransferWriter
  def initialize(datePrefix)
    super
    @tool = SepaTool.new(INVOICE_CONFIG)
    @credit_transfers = []
  end

  def addCreditTransfer(regional_organization, remittance_txt, amount)
    customer = regional_organization.to_customer

    unless customer.is_direct_debit?
      Rails.logger.info("LV #{regional_organization.name} is not considered for CreditTransfer!")
      return
    end

    ct = SepaCreditTransfer.new(customer, amount)
    ct.remittance_txt = remittance_txt

    @credit_transfers << ct
  end

  def generateFile
    writeXml
  end

  private

  def writeXml
    return nil if @credit_transfers.count == 0

    sepaxml = @tool.create_credit_transfer(@credit_transfers)

    filename = @date_prefix + '_sepa_ct.xml'
    outfile = MailingFile.new(filename, filename, Time.now.year.to_s)
    sepaFile = File.open(outfile.full_path, 'w')
    sepaFile << sepaxml
    sepaFile.close

    outfile
  end
end
