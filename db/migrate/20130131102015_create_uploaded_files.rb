class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :filename
      t.integer :report_sheet_input_id
      t.integer :correct_ds
      t.integer :faulty_ds

      t.timestamps
    end
  end
end
