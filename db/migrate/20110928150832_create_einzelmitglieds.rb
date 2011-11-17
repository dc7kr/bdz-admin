class CreateEinzelmitglieds < ActiveRecord::Migration
  def change
    create_table :einzelmitglieds do |t|
      t.long :mitgliedsnummer
      t.string :anrede
      t.string :vorname
      t.string :nachname
      t.string :strasse
      t.string :landeskennzeichen
      t.string :plz
      t.string :ort
      t.date :geburtstag
      t.string :telPriv
      t.string :telDienst
      t.string :fax
      t.date :eintritt
      t.string :za
      t.bignum :konto
      t.bignum :blz
      t.string :zahler
      t.references :lv
      t.double :beitragsart
      t.string :bemerkung
      t.integer :zeitungen
      t.date :austrittZum
      t.date :kuendigungVom
      t.double :beitrag
      t.bignum :zusatzzeitung
      t.string :eMail
      t.bool :lastschriftErfasst
      t.bool :rechnungsDruck
      t.integer :jahreszahl

      t.timestamps
    end
    add_index :einzelmitglieds, :lv_id
  end
end
