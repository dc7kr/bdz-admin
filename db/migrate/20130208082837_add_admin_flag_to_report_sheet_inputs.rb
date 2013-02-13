class AddAdminFlagToReportSheetInputs < ActiveRecord::Migration
  def change
    add_column :report_sheet_inputs, :admin_flag, :boolean
  end
end
