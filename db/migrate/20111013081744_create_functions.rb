class CreateFunctions < ActiveRecord::Migration[4.2]
  def change
    create_table :functions do |t|
      t.string :label
      t.references :lv
      t.references :address
      t.boolean :bund
      t.boolean :jugend
      t.integer :nr
      t.string :funktion
      t.string :fktSubtitle

      t.timestamps
    end
  end
end
