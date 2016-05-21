class AddCountryCodeToCourses < ActiveRecord::Migration
  def change
      add_column :courses, :country_code, :string, :limit=>2
  end
end
