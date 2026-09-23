class AddCountryCodeToCourses < ActiveRecord::Migration[4.2]
  def change
      add_column :courses, :country_code, :string, :limit=>2
  end
end
