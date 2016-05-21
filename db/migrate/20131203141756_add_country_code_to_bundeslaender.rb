class AddCountryCodeToBundeslaender< ActiveRecord::Migration
  def change
      add_column :bundeslaender, :country_code, :string, :limit=>2
  end
end
