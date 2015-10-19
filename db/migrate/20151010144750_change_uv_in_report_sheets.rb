class ChangeUvInReportSheets < ActiveRecord::Migration
  def up
    change_column :report_sheets, :uv, :boolean
  end

  def down
  end
end
