class CreateOrchestras < ActiveRecord::Migration
  def change
    create_table :orchestras do |t|
      t.int :mglnr
      t.string :orchName
      t.string :anrede
      t.string :vorname
      t.string :nachname
      t.string :strasse
      t.string :land
      t.string :plz
      t.string :ort
      t.string :telefon
      t.string :fax
      t.date :gruendung
      t.date :eintritt
      t.string :za
      t.bignum :konto
      t.bignum :blz
      t.references :lv
      t.string :zw
      t.int :zeitungen
      t.int :gema
      t.int :numBis14
      t.int :num15bis18
      t.int :num19bis27
      t.int :numUeber27
      t.int :sumMitglieder
      t.int :azubi
      t.int :passive
      t.double :beitrag
      t.bool :unfallversicherung
      t.bool :meldebogen
      t.bool :rechnungsDruck
      t.bool :koopMitglied
      t.date :austrittZum
      t.date :schreibenVom
      t.double :uvBetrag
      t.double :rechnungsbetrag
      t.bool :versaeumniszuschlag
      t.double :vZuschlag
      t.bool :mahngebuehr1
      t.bool :mahngebuehr2
      t.double :mGebuehr1
      t.double :mGebuehr2
      t.string :bemerkung
      t.string :eMail
      t.string :url
      t.bool :lastschriftErfasst
      t.bool :kuendigungErfasst
      t.string :zweitanschrift
      t.string :name2
      t.int :dageVER
      t.int :haftpflichtVers
      t.double :haftpflichtGebuehrLV
      t.double :lvGebuehr
      t.int :uvZusatzzahl
      t.int :uvZahl
      t.int :jahreszahl

      t.timestamps
    end
    add_index :orchestras, :lv_id
  end
end
