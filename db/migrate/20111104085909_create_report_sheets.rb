class CreateReportSheets < ActiveRecord::Migration
  def change
    create_table :report_sheets do |t|
      t.int,orchestra :year
      t.int,teens :children
      t.int,adult :youth

      t.timestamps
    end
  end
end
