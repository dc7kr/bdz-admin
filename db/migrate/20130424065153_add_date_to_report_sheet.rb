class AddDateToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :report_date, :date
    add_column(:report_sheets, :created_at, :datetime)
    add_column(:report_sheets, :updated_at, :datetime)
  end
end
