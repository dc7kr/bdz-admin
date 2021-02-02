class RemoveDeprecatedColumnsFromPersonMembers < ActiveRecord::Migration[4.2]
  def up
    remove_column :person_members, :mitgliedsnummer
    remove_column :person_members, :anrede
    remove_column :person_members, :vorname
    remove_column :person_members, :nachname
    remove_column :person_members, :strasse
    remove_column :person_members, :land
    remove_column :person_members, :plz
    remove_column :person_members, :Ort
    remove_column :person_members, :telefonPrivat
    remove_column :person_members, :telefax
    remove_column :person_members, :eintritt
    remove_column :person_members, :za
    remove_column :person_members, :konto
    remove_column :person_members, :blz
    remove_column :person_members, :zahler
    remove_column :person_members, :austrittZum
    remove_column :person_members, :eMail
    remove_column :person_members, :jahreszahl
  end

  def down
  end
end
