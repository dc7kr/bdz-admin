require 'sepa_tool'

class SEPAWriter
  attr_accessor :datePrefix,:message_id

  def initialize(msg_id)
		datePrefix=Time.now.strftime '%Y%m%d%H%M%S_'
    message_id = msg_id
    @tool = SEPATool.new
    @direct_debits = Array.new
	end

	def self.workdir
		BDZ_SETTINGS['invoice_workdir']+"/"
	end

	def sepaFileName
		SEPAWriter.workdir+datePrefix+".sepa.xml"
	end

  def gen_end_to_end_id(member)
    "BDZ-Beitrag "+year.to_s+" "+member.mglnr.to_s
  end

  def dd_from_member(member) 
    SepaDirectDebit.new
    dd.iban = person.iban
    dd.bic = person.bic

    dd.mandate_id = person.mandate_id
    dd.sig_date = person.sig_date
    dd.sequence_type = "RCUR" # we directly use Recurring payment - if not accepted we have to change it to FRST
    dd.end_to_end_id = gen_end_to_end_id(person)

    return dd
  end

  def addOrchestraTariff(orch)
    dd = dd_from_member(orch)
    dd.amount = orchestra.currentReportSheet.calcInvoice

    @direct_debits << dd
  end

  def addPersonTariff(person)
    dd = dd_from_member(person)
    dd.amount = person.tariff.amount
    @direct_debits << dd
  end

  def writeXml(collection_date, payment_id)
    sepaxml = @tool.create_sepa_direct_debit_order(@direct_debits, message_id, payment_id, collection_date)
    xml = @tool.create_direct_debit(@direct_debits)
    sepaFile = File.open(sepaFileName,"w")
    sepaFile << xml
    sepaFile.close
  end
end
