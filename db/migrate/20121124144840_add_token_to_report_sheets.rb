class AddTokenToReportSheets < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :token, :string

  end
end
