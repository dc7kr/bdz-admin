class AddCountryCodeToOrchestraContacts < ActiveRecord::Migration
  def change
    add_column :orchestra_contacts, :country_code, :string
  end
end
