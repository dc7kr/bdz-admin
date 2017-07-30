require 'sepa_tool'

class SEPAWriter < BankTransferWriter
  attr_accessor :direct_debits,:credit_transfers,:year,:tool
  
  def initialize(date_prefix,settings,year=nil)
    super(date_prefix, settings['invoice_workdir']+"/")

    if year.nil? then
      self.year = Time.now.year
    else
      self.year = year
    end

    self.tool = SEPATool.new(settings)
    self.direct_debits = Array.new
    self.credit_transfers = Array.new
  end


  public
  def addDirectDebit(customer, amount, remittance_txt,sequence_type=nil)
    if self.credit_transfers.count > 0 
      false
    else
      dd = SepaDirectDebit.new(customer,sequence_type)
      dd.remittance_txt = remittance_txt
      dd.amount = amount 

      Rails.logger.debug("New booking: #{customer.id}: #{dd.sequence_type}: #{amount}")
      self.direct_debits << dd

      true
    end
  end

  def addCreditTransfer(customer,remittance_txt, amount) 
    if self.direct_debits.count > 0 
      false
    else
      if not customer.is_direct_debit? then
        Rails.logger.info("Customer #{customer.customer_id} is not considered for CreditTransfer - no IBAN/BIC!")
        return false
      end

      ct = SEPACreditTransfer.new(customer,amount) 
      ct.remittance_txt = remittance_txt

      self.credit_transfers << ct
      
      true
    end
  end

  def generateFile
    writeXml
  end

  def addOrchestraTariff(orch,remittance_txt)
    addBooking(orch, currentReportSheet.calcInvoice, remittance_txt)
  end

  def filename
    if self.direct_debits.count >0 
      self.date_prefix+"_sepa_dd.xml"
    elsif self.credit_transfers.count >0 
      self.date_prefix+"_sepa_ct.xml"
    else
      nil
    end
  end

  private
  def writeXml
    if self.direct_debits.count == 0 and self.credit_transfers.count == 0
      return nil
    end

    sepaxml = nil
    if self.direct_debits.count > 0 
      sepaxml = self.tool.create_sepa_direct_debit_order(self.direct_debits)
    elsif self.credit_transfers.count > 0 
      sepaxml = self.tool.create_credit_transfer(self.credit_transfers)
    end

    outfile = MailingFile.new(self.filename,self.filename,self.year.to_s)
    sepaFile = File.open(outfile.full_path,"w")
    sepaFile << sepaxml
    sepaFile.close

    outfile
  end
end
