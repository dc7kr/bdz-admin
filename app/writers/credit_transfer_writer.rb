class CreditTransferWriter < BankTransferWriter

  def initialize(datePrefix,settings)
    super(datePrefix)
    @tool = SEPATool.new(settings)
    @credit_transfers = Array.new
  end

  def addCreditTransfer(regional_organization,remittance_txt, amount) 
    ct = SEPACreditTransfer.new(regional_organization.to_customer,amount) 
    ct.remittance_txt = remittance_txt

    @credit_transfers << ct
  end

  def generateFile
    writeXml
  end

  private
  def writeXml
    if @credit_transfers.count == 0 
      return nil
    end
    
    sepaxml = @tool.create_credit_transfer(@credit_transfers)

    filename = @datePrefix+"_sepa_ct.xml"
    outfile = MailingFile.new(filename,filename,Time.now.year.to_s)
    sepaFile = File.open(outfile.full_path,"w")
    sepaFile << sepaxml
    sepaFile.close

    outfile
  end
end
