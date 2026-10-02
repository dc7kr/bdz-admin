# devise :rememberable needs users.remember_created_at. The MySQL databases have it
# (added outside of the migrations), databases built from the migrations don't.
class AddRememberCreatedAtToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :remember_created_at, :datetime unless column_exists?(:users, :remember_created_at)
  end

  def down
    # the column existed before this migration on MySQL, so keep it
  end
end
