class RemoveRolesFromUsers < ActiveRecord::Migration[4.2]
  def up
    remove_column :users, :role
  end

end
