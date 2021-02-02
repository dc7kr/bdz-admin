class AddCountryCodeToFestivals < ActiveRecord::Migration[4.2]
  def change
      add_column :festivals, :country_code, :string, :limit=>2
  end
end
