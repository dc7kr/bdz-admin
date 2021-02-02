class AddAdminFlagToReportSheetInputs < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheet_inputs, :admin_flag, :boolean
  end
end
