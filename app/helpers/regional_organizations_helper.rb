module RegionalOrganizationsHelper

  def report_sheet_count(rs, key) 
    if rs.nil? then
      "---"
    else
      rs.send(key)
    end
  end
end
