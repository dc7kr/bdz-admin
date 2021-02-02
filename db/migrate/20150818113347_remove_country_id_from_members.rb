class RemoveCountryIdFromMembers < ActiveRecord::Migration[4.2]
  def up
    remove_column :members, :country_id
  end

  def down
  end
end
