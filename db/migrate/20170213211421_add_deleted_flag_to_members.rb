class AddDeletedFlagToMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :deleted, :boolean
  end
end
