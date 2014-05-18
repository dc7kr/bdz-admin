class AddCorrectToCompetitionEntries < ActiveRecord::Migration
  def change
    add_column :competition_entries, :correct, :boolean
  end
end
