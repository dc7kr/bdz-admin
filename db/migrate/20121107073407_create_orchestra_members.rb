class CreateOrchestraMembers < ActiveRecord::Migration
  def change
    create_table :orchestra_members do |t|
      t.references :orchestra
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth

      t.timestamps
    end
    add_index :orchestra_members, :orchestra_id
  end
end
