class CreateUniversities < ActiveRecord::Migration[4.2]
  def change
    create_table :hochschulen do |t|
      t.string :name
      t.string :institut
      t.string :strasse
      t.string :plz
      t.string :ort
      t.references :land
      t.string :telefon
      t.string :studiengang
      t.string :dozent
      t.string :email
      t.string :homepage

      t.timestamps
    end
  end
end
