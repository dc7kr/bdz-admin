require 'sepa_tool'

class SEPAWriter < BankTransferWriter
  
  def initialize(datePrefix,settings,year=nil)
    super(datePrefix)
    if year.nil? then
      @year = Time.now.year
    else
      @year = year
    end

    @tool = SEPATool.new(settings)
    @direct_debits = Array.new
  end

  private
  def dd_from_member(member,seq_type=nil) 
    dd = SepaDirectDebit.new(member,seq_type)
    return dd
  end

  public
  def addBooking(customer, amount, remittance_txt,sequence_type=nil)
    dd = dd_from_member(customer,sequence_type)
    dd.remittance_txt = remittance_txt
    dd.amount = amount 

    Rails.logger.debug("New booking: #{customer.id}: #{dd.sequence_type}: #{amount}")
    @direct_debits << dd
  end

  def generateFile
    writeXml
  end

  def addOrchestraTariff(orch,remittance_txt)
    addBooking(orch, currentReportSheet.calcInvoice, remittance_txt)
  end

  private
  def writeXml
    if @direct_debits.count == 0 
      return nil
    end
    
    sepaxml = @tool.create_sepa_direct_debit_order(@direct_debits)

    filename = @datePrefix+"_sepa.xml"
    outfile = MailingFile.new(filename,filename,@year.to_s)
    sepaFile = File.open(outfile.full_path,"w")
    sepaFile << sepaxml
    sepaFile.close

    outfile
  end
end
