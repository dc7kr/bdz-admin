class RemoveZeitungenFromReportSheets < ActiveRecord::Migration[4.2]
  def up
    remove_column :report_sheets, :zeitungen
  end

  def down
    add_column :report_sheets, :zeitungen, :integer
  end
end
