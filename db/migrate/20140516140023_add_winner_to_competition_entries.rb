class AddWinnerToCompetitionEntries < ActiveRecord::Migration
  def change
    add_column :competition_entries, :winner, :boolean, :default=>false
  end
end
