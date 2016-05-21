class AddCountryCodeToContacts < ActiveRecord::Migration
  def change
      add_column :contacts, :country_code, :string, :limit=>2
  end
end
