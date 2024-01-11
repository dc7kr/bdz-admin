class AddLockedFlagToReportSheetInputs < ActiveRecord::Migration[5.2]
  def change
    add_column :report_sheet_inputs, :locked, :boolean
  end
end
