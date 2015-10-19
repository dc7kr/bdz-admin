class RemoveZeitungenFromReportSheets < ActiveRecord::Migration
  def up
    remove_column :report_sheets, :zeitungen
  end

  def down
    add_column :report_sheets, :zeitungen, :integer
  end
end
