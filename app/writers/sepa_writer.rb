require 'sepa_tool'

class SEPAWriter < DirectDebitWriter
  
  def initialize(datePrefix=nil)
    super(datePrefix)
    @tool = SEPATool.new
    @direct_debits = Array.new
  end

  def output_dir
    year = Time.now.year.to_s
	  BDZ_SETTINGS['invoice_archive_dir']+"/"+year+"/"
  end

  def output_file
	  @datePrefix+"_sepa.xml"
  end
    
	def full_filename
	  output_dir+output_file
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
    @direct_debits << dd
  end

  def generateFile
    writeXml
    # must be without PATH!!!
    output_file
  end

  def addOrchestraTariff(orch,remittance_txt)
    addBooking(orch, currentReportSheet.calcInvoice, remittance_txt)
  end

  private
  def writeXml
    sepaxml = @tool.create_sepa_direct_debit_order(@direct_debits)
    sepaFile = File.open(full_filename,"w")
    sepaFile << sepaxml
    sepaFile.close
  end

end
