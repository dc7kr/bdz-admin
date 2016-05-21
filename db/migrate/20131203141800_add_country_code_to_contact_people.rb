class AddCountryCodeToContactPeople< ActiveRecord::Migration
  def change
      add_column :contact_people, :country_code, :string, :limit=>2
  end
end
