class CreateFestivals < ActiveRecord::Migration[4.2]
  def change
    create_table :festivals do |t|
      t.date :startdate
      t.date :enddate 
      t.references :land 
      t.references :bland
      t.string :name
      t.string :description
      t.string :anmeldung
      t.string :gebuehren
      t.string :stadt
      t.string :homepage
      t.string :ort
      t.string :ortdetails
      t.references :owner
      t.boolean :visible

      t.timestamps
    end
  end
end
