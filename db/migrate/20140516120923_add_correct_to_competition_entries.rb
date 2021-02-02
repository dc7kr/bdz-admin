class AddCorrectToCompetitionEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :competition_entries, :correct, :boolean
  end
end
