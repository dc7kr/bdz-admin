class AddCountryCodeToConcerts< ActiveRecord::Migration
  def change
      add_column :concerts, :country_code, :string, :limit=>2
  end
end
