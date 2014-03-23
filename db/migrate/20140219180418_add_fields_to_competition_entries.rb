class AddFieldsToCompetitionEntries < ActiveRecord::Migration
  def change
    add_column :competition_entries, :first_name, :string
    add_column :competition_entries, :last_name, :string
    add_column :competition_entries, :street, :string
    add_column :competition_entries, :city, :string
    add_column :competition_entries, :zip, :string
    add_column :competition_entries, :country_code, :string
    add_column :competition_entries, :email, :string
  end
end
