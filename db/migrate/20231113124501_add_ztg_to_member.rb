class AddZtgToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :magazines, :integer, :null => false, :default => -1
  end
end
