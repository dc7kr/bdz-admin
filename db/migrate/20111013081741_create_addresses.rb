class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string,titel :anrede
      t.string, :name
      t.string, :strasse
      t.string, :plz
      t.string,telefon :ort
      t.string :mobil
      t.string, :fax
      t.string :email

      t.timestamps
    end
  end
end
