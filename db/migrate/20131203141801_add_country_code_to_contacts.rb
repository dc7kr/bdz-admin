class AddCountryCodeToContacts < ActiveRecord::Migration[4.2]
  def change
      add_column :contacts, :country_code, :string, :limit=>2
  end
end
