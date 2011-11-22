class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.date :datum
      t.time :zeit
      t.datetime :reported
      t.datetime :confirmed
      t.string :token
      t.string :stadt
      t.string :titel
      t.string :ort
      t.references :festival
      t.string :interpret
      t.string :homepage
      t.string :bemerkung
      t.references :bland
      t.references :land
      t.string :email
      t.string :url
      t.float :eintritt
      t.references :owner
      t.boolean :visible 

      t.timestamps
    end
  end
end
