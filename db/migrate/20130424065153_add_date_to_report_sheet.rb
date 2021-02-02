class AddDateToReportSheet < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :report_date, :date
  end
end
