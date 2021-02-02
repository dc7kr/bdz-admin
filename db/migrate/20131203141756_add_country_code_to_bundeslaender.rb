class AddCountryCodeToBundeslaender< ActiveRecord::Migration[4.2]
  def change
      add_column :bundeslaender, :country_code, :string, :limit=>2
  end
end
