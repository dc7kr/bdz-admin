class AddContactEntityToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :contact_entity_id, :integer
    add_column :contacts, :contact_entity_type, :string
  end
end
