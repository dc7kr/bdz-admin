class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.date :startdate
      t.date :enddate
      t.string :titel
      t.string :beschreibung
      t.string :gebuehr
      t.string :preis
      t.string :anmeldung
      t.string :email
      t.datetime :deadline
      t.datetime :confirmed 
      t.datetime :reported
      t.boolean :visible

      t.timestamps
    end
  end
end
