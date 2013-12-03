class AddCountryCodeToModels < ActiveRecord::Migration
  def change
      add_column :bundeslaender, :country_code, :string, :limit=>2
      add_column :urls, :country_code, :string, :limit=>2
      add_column :concerts, :country_code, :string, :limit=>2
      add_column :festivals, :country_code, :string, :limit=>2
      add_column :contact_people, :country_code, :string, :limit=>2
      add_column :contacts, :country_code, :string, :limit=>2
      add_column :hochschulen, :country_code, :string, :limit=>2
  end
end
