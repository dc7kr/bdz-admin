class ChangeUvInReportSheets < ActiveRecord::Migration[4.2]
  def up
    change_column :report_sheets, :uv, :boolean
  end

  def down
  end
end
