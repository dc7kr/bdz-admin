class AddZtgFieldsToReportSheets < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :korr_ztg, :integer
    add_column :report_sheets, :senior, :integer
    add_column :report_sheets, :zusatz_uv, :integer
    add_column :report_sheets, :zusatz_ztg, :integer
  end
end
