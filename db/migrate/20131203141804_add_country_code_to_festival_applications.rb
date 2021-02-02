class AddCountryCodeToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
      add_column :festival_applications, :country_code, :string, :limit=>2
  end
end
