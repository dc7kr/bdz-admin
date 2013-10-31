class AddGeneratedFlagToReportSheets < ActiveRecord::Migration
  def change
    add_column :report_sheets, :generated, :boolean
  end
end
