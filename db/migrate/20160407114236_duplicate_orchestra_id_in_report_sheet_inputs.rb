class DuplicateOrchestraIdInReportSheetInputs < ActiveRecord::Migration
  def change
    rename_column :report_sheet_inputs, :orchestra_id, :orchestra_id_old
    add_column :report_sheet_inputs, :orchestra_id, :integer
  end
end
