class AddDateToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :report_date, :date
  end
end
