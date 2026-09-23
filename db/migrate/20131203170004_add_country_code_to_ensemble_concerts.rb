class AddCountryCodeToEnsembleConcerts < ActiveRecord::Migration[4.2]
  def change
      add_column :ensemble_concerts, :country_code, :string, :limit=>2
  end
end
