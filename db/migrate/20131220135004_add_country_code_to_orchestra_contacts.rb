class AddCountryCodeToOrchestraContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :orchestra_contacts, :country_code, :string
  end
end
