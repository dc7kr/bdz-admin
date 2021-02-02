class AddCountryCodeToUrls < ActiveRecord::Migration[4.2]
  def change
      add_column :urls, :country_code, :string, :limit=>2
  end
end
