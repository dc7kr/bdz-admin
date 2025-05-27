module RegionalOrganizationReportsHelper
  def report_sheet_count(rs, key)
    if rs.nil?
      "---"
    else
      rs.send(key)
    end
  end
end
