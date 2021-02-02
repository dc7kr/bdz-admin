class AddResponsesToCompetitionEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :competition_entries, :response1, :string
    add_column :competition_entries, :response2, :string
    add_column :competition_entries, :response3, :string
    add_column :competition_entries, :response4, :string
  end
end
