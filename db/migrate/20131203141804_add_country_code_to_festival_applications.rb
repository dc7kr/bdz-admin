class AddCountryCodeToFestivalApplications < ActiveRecord::Migration
  def change
      add_column :festival_applications, :country_code, :string, :limit=>2
  end
end
