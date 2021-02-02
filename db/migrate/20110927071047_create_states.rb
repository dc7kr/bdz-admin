class CreateStates < ActiveRecord::Migration[4.2]
  def change
    create_table :states do |t|
      t.string :name
      t.references :country

      t.timestamps
    end
    add_index :states, :country_id
  end
end
