class AddTokenToReportSheets < ActiveRecord::Migration
  def change
    add_column :report_sheets, :token, :string

  end
end
