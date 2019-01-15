class ChangeClassifiedsIpLength < ActiveRecord::Migration
  def up
    change_column :classifieds, :ip, :string, :limit => 45,:null=>false
  end

  def down
    change_column :classifieds, :ip, :string, :limit => 20,:null=>false
  end
end
