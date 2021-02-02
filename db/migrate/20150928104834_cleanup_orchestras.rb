class CleanupOrchestras < ActiveRecord::Migration[4.2]
  def up
    change_table :orchestras do |t|
    t.remove  :mglnr
    t.remove  :anrede
    t.remove  :vorname
    t.remove  :nachname
    t.remove  :strasse
    t.remove  :plz
    t.remove  :ort
    t.remove  :telefon
    t.remove  :fax
    t.remove  :eintritt
    t.remove  :za
    t.remove  :konto
    t.remove  :blz
    t.remove  :lv_id
    t.remove  :zw
    t.remove  :zeitungen
    t.remove  :gema
    t.remove  :numBis14
    t.remove  :num15bis18
    t.remove  :num19bis27
    t.remove  :numUeber27
    t.remove  :sumMitglieder
    t.remove  :azubi
    t.remove  :passive
    t.remove  :beitrag
    t.remove  :unfallversicherung
    t.remove  :meldebogen
    t.remove  :rechnungsDruck
    t.remove  :koopMitglied
    t.remove  :austrittZum
    t.remove  :schreibenVom
    t.remove  :uvBetrag
    t.remove  :rechnungsbetrag
    t.remove  :versaeumniszuschlag
    t.remove  :vZuschlag
    t.remove  :mahngebuehr1
    t.remove  :mahngebuehr2
    t.remove  :mGebuehr1
    t.remove  :mGebuehr2
    t.remove  :eMail
    t.remove  :lastschriftErfasst
    t.remove  :dageVER
    t.remove  :haftpflichtVers
    t.remove  :haftpflichtGebuehrLV
    t.remove  :lvGebuehr
    t.remove  :uvZusatzzahl
    t.remove  :uvZahl
    t.remove  :jahreszahl
    end

  end
  def down
  end
end
