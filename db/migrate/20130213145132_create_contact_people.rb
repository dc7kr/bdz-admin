class CreateContactPeople < ActiveRecord::Migration[4.2]
  def change
    create_table :contact_people do |t|
      t.string :salutation
      t.string :first_name
      t.string :last_name
      t.string :street
      t.string :zip
      t.string :city
      t.integer :country_id
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
