class RemovePasswdFromUsers < ActiveRecord::Migration[4.2]


  def up
      remove_column :users, :passwd
  end

  def down
  end
end
