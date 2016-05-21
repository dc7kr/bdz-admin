class DuplicateOrchestraIdInReportSheets < ActiveRecord::Migration
  def change
    rename_column :report_sheets, :orchestra_id, :orchestra_id_old
    add_column :report_sheets, :orchestra_id, :integer
  end
end
