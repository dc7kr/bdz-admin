class RemoveCountryIdFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :country_id
  end

  def down
  end
end
