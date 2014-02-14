class MakeConfirmationsNullable < ActiveRecord::Migration
  def up
    change_column :ensemble_concerts, :confirmed, :datetime, :null => true
    change_column :concerts, :confirmed, :datetime, :null => true
    change_column :classifieds, :confirmed, :datetime, :null => true
    change_column :courses, :confirmed, :datetime, :null => true
  end

  def down
  end
end
