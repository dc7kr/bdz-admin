class CreateComposers < ActiveRecord::Migration[4.2]
  def change
    create_table :composers do |t|
      t.string :name
      t.string :vorname
      t.string :gebjahr
      t.string :sterbejahr
      t.boolean :ca_geb
      t.boolean :ca_sterb
      t.references :fk_ref_komp
      t.string :comment

      t.timestamps
    end
    add_index :composers, :fk_ref_komp_id
  end
end
