class AddCountryCodeToRemainingModels < ActiveRecord::Migration
  def change
      add_column :kurse, :country_code, :string, :limit=>2
      add_column :festival_applications, :country_code, :string, :limit=>2
      add_column :konz_ensemble, :country_code, :string, :limit=>2
  end
end
