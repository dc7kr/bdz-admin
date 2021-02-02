class AddFeedbackToCompetitionEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :competition_entries, :like, :string
    add_column :competition_entries, :missing, :string
    add_column :competition_entries, :improve, :string
  end
end
