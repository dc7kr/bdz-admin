class RemovePasswdFromUsers < ActiveRecord::Migration


  def up
      remove_column :users, :passwd
  end

  def down
  end
end
