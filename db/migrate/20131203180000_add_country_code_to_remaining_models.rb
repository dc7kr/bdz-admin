class AddCountryCodeToRemainingModels < ActiveRecord::Migration
  def change
      add_column :courses, :country_code, :string, :limit=>2
      add_column :festival_applications, :country_code, :string, :limit=>2
      add_column :ensemble_concerts, :country_code, :string, :limit=>2
  end
end
