class AddCountryCodeToContactPeople< ActiveRecord::Migration[4.2]
  def change
      add_column :contact_people, :country_code, :string, :limit=>2
  end
end
