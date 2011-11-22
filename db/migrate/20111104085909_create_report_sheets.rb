class CreateReportSheets < ActiveRecord::Migration
  def change
    create_table :report_sheets do |t|
	t.integer 	:year 	
	t.references :orchestra
	t.integer 	:children
	t.integer	:teens 	
	t.integer	:youth 	
	t.integer 	:adult 	
	t.integer 	:uv 	
	t.integer	:zeitungen 	
	t.integer	:gema 	
	t.integer	:azubi 	
	t.integer	:passive
      t.timestamps
    end
  end
end
