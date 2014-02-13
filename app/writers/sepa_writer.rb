require 'sepa_tool'

class SEPAWriter < DirectDebitWriter
  
  def initialize(datePrefix=nil)
    super(datePrefix)
    @tool = SEPATool.new
    @direct_debits = Array.new
  end

  private
  def dd_from_member(member,seq_type=nil) 
    dd = SepaDirectDebit.new(member,seq_type)
    return dd
  end

  public
  def addBooking(member, amount, remittance_txt,sequence_type=nil)
    dd = dd_from_member(member,sequence_type)
    dd.remittance_txt = remittance_txt
    dd.amount = amount 

    Rails.logger.debug("New booking: "+member.mglnr.to_s+": "+dd.sequence_type.to_s+": "+amount.to_s)
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
    outfile = MailingFile.new(filename,filename,Time.now.year.to_s)
    sepaFile = File.open(outfile.full_path,"w")
    sepaFile << sepaxml
    sepaFile.close

    outfile
  end
end
