class AddAzubiToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :azubi_child, :integer
    add_column :report_sheets, :azubi_teens, :integer
    add_column :report_sheets, :azubi_youth, :integer
    add_column :report_sheets, :azubi_adult, :integer
    add_column :report_sheets, :azubi_senior, :integer

  end
end
