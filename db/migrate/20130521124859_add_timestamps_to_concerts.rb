class AddTimestampsToConcerts < ActiveRecord::Migration
  def up
		change_table :concerts do |t|
			t.timestamps
		end
  end

  def down
    remove_column :concerts, :created_at
    remove_column :concerts, :updated_at
  end
end
