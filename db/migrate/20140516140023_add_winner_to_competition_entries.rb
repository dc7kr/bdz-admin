class AddWinnerToCompetitionEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :competition_entries, :winner, :boolean, :default=>false
  end
end
