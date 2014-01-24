class DropCountryColumnFromOrchestraContacts < ActiveRecord::Migration
  def up
     remove_column :orchestra_contacts, :country
  end

  def down
  end
end
