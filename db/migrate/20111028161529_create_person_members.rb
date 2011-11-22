class CreatePersonMembers < ActiveRecord::Migration
  def change
    create_table :person_members do |t|
  t.integer :mitgliedsnummer
  t.string :anrede
  t.string :vorname
  t.string :nachname
  t.string :strasse
  t.string :land
  t.string :plz
  t.string :Ort
  t.date :geburtstag
  t.string :telefonPrivat
  t.string :telefonDienstl
  t.string :telefax
  t.date :eintritt 
  t.string :za
  t.integer :konto
  t.integer :blz
  t.string :zahler
  t.integer :lv
  t.integer :beitragsart
  t.string :bemerkung
  t.integer :zeitungen 
  t.date :austrittZum
  t.date :kuendigungVom
  t.decimal :beitrag
  t.integer :zusatzzeitung
  t.string :eMail
  t.boolean :lastschriftErfasst
  t.boolean :rechnungsDruck
  t.integer :jahreszahl
      t.timestamps
    end
  end
end
