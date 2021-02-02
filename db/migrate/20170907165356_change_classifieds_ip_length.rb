class ChangeClassifiedsIpLength < ActiveRecord::Migration[4.2]
  def up
    change_column :classifieds, :ip, :string, :limit => 45,:null=>false
  end

  def down
    change_column :classifieds, :ip, :string, :limit => 20,:null=>false
  end
end
