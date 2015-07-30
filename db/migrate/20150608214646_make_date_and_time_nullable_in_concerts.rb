class MakeDateAndTimeNullableInConcerts < ActiveRecord::Migration
  def up
    change_column :concerts, :datum, :date, :null => true
    change_column :concerts, :zeit, :time, :null => true
  end

  def down
  end
end
