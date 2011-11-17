class CreateFestivals < ActiveRecord::Migration
  def change
    create_table :festivals do |t|
      t.date,enddate :startdate
      t.references,land :bland
      t.string, :name
      t.string, :description
      t.string, :anmeldung
      t.string, :gebuehren
      t.string, :stadt
      t.string, :homepage
      t.string, :ort
      t.string,owner :ortdetails
      t.bool :visible

      t.timestamps
    end
  end
end
