class CreateReportSheetInputs < ActiveRecord::Migration
  def change
    create_table :report_sheet_inputs do |t|
      t.references :report_sheet
      t.references :orchestra
      t.string :token

      t.timestamps
    end
    add_index :report_sheet_inputs, :report_sheet_id
    add_index :report_sheet_inputs, :orchestra_id
  end
end
