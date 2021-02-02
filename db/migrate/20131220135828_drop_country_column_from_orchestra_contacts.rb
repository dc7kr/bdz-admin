class DropCountryColumnFromOrchestraContacts < ActiveRecord::Migration[4.2]
  def up
     remove_column :orchestra_contacts, :country
  end

  def down
  end
end
