class CreateOrchestraContacts < ActiveRecord::Migration
  def change
    create_table :orchestra_contacts do |t|
      t.references :orchestra
      t.string :salutation
      t.string :first_name
      t.string :last_name
      t.string :street
      t.string :zip
      t.string :city
      t.string :country
      t.string :role
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :orchestra_contacts, :orchestra_id
  end
end
