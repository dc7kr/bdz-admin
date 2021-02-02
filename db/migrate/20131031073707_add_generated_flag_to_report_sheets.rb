class AddGeneratedFlagToReportSheets < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :generated, :boolean
  end
end
