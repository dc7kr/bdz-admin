module RegionalOrganizationHelper

  def report_sheet_count(rs, key) 
    if rs.nil? then
      "---"
    else
      rs[key]
    end
  end
end
