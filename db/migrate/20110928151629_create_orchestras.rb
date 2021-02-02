class CreateOrchestras < ActiveRecord::Migration[4.2]
  def change
    create_table :orchestras do |t|
      t.integer :mglnr
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
      t.column :konto, 'bigint'
      t.column :blz, 'bigint'
      t.references :lv
      t.string :zw
      t.integer :zeitungen
      t.integer :gema
      t.integer :numBis14
      t.integer :num15bis18
      t.integer :num19bis27
      t.integer :numUeber27
      t.integer :sumMitglieder
      t.integer :azubi
      t.integer :passive
      t.decimal :beitrag
      t.boolean :unfallversicherung
      t.boolean :meldebogen
      t.boolean :rechnungsDruck
      t.boolean :koopMitglied
      t.date :austrittZum
      t.date :schreibenVom
      t.decimal :uvBetrag
      t.decimal :rechnungsbetrag
      t.boolean :versaeumniszuschlag
      t.decimal :vZuschlag
      t.boolean :mahngebuehr1
      t.boolean :mahngebuehr2
      t.decimal :mGebuehr1
      t.decimal :mGebuehr2
      t.string :bemerkung
      t.string :eMail
      t.string :url
      t.boolean :lastschriftErfasst
      t.boolean :kuendigungErfasst
      t.string :zweitanschrift
      t.string :name2
      t.integer :dageVER
      t.integer :haftpflichtVers
      t.decimal :haftpflichtGebuehrLV
      t.decimal :lvGebuehr
      t.integer :uvZusatzzahl
      t.integer :uvZahl
      t.integer :jahreszahl

      t.timestamps
    end
    add_index :orchestras, :lv_id
  end
end
