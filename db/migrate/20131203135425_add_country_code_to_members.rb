class AddCountryCodeToMembers < ActiveRecord::Migration
  def up
    add_column :members, :country_code, :string, :limit=>2
  end

  def down
  end
end
