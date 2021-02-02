class AddCountryCodeToConcerts< ActiveRecord::Migration[4.2]
  def change
      add_column :concerts, :country_code, :string, :limit=>2
  end
end
