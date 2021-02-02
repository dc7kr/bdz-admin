class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.string :titel
      t.string :anrede
      t.string :name
      t.string :strasse
      t.string :plz
      t.string :telefon
      t.string :ort
      t.string :mobil
      t.string :fax
      t.string :email
      t.timestamps
    end
  end
end
