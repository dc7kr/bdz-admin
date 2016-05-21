class AddCountryCodeToFestivals < ActiveRecord::Migration
  def change
      add_column :festivals, :country_code, :string, :limit=>2
  end
end
