class AddCountryCodeToUrls < ActiveRecord::Migration
  def change
      add_column :urls, :country_code, :string, :limit=>2
  end
end
