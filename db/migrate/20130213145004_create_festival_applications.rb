class CreateFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :festival_applications do |t|
      t.integer :country_id
      t.integer :orchestra_id
      t.text :orch_name
      t.text :conductor
      t.integer :num_players
      t.text :equipment
      t.text :special_cast
      t.integer :contact_person_id

      t.timestamps
    end
  end
end
