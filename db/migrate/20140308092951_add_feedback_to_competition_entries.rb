class AddFeedbackToCompetitionEntries < ActiveRecord::Migration
  def change
    add_column :competition_entries, :like, :string
    add_column :competition_entries, :missing, :string
    add_column :competition_entries, :improve, :string
  end
end
