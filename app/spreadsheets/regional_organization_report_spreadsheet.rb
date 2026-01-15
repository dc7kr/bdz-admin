class RegionalOrganizationReportSpreadsheet

  attr_accessor :regional_organization, :sheet

  def initialize(regional_organization)
    self.regional_organization = regional_organization
  end

  def gen_file(tmp_name = nil )
    
    filename = tmp_name 

    if filename.nil?
      tmpfile = Tempfile.new("mgl")
      filename = tmpfile.path

      sheet.write_to filename
     end

     filename
  end

  def bytes
    self.sheet.bytes
  end
end
