class CreditTransferWriter
  attr_accessor :date_prefix, :outfile, :workdir

  def initialize(date_prefix = nil)
    self.date_prefix date_prefix

    if self.date_prefix.nil?
      self.date_prefix = Time.zone.now.strftime "%Y%m%d%H%M%S"
    end

    @tool = SepaTool.new(INVOICE_CONFIG)
    @credit_transfers = []
  end

  def override_date(pref)
    self.date_prefix = "#{pref}_"
  end


  def add_credit_transfer(regional_organization, remittance_txt, amount)
    customer = regional_organization.to_customer

    unless customer.direct_debit?
      Rails.logger.info("LV #{regional_organization.name} is not considered for CreditTransfer!")
      return
    end

    ct = SepaCreditTransfer.new(customer, amount)
    ct.remittance_txt = remittance_txt

    @credit_transfers << ct
  end

  def generate_file
    writeXml
  end

  private

  def write_xml
    return nil if @credit_transfers.count.zero?

    sepaxml = @tool.create_credit_transfer(@credit_transfers)

    filename = "#{@date_prefix}_sepa_ct.xml"
    outfile = MailingFile.new(filename, filename, Time.zone.now.year.to_s)
    sepa_file = File.open(outfile.full_path, "w")
    sepa_file << sepaxml
    sepa_file.close

    outfile
  end
end
