class CreateCompetitions < ActiveRecord::Migration[4.2]
  def change
    create_table :competition_entries do |t|
      t.date :date_of_birth
      t.integer :contact_id

      t.timestamps
    end
  end
end
