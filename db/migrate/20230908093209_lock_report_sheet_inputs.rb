class LockReportSheetInputs < ActiveRecord::Migration[5.2]
  def change
    ReportSheetInput.includes(:report_sheet).each do |ri|
      if ri.report_sheet.year < 2024
        ri.locked=true
      else 
        ri.locked=false
      end
      ri.save
    end
  end
end
