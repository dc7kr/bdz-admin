class AddContactEntityToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_entity_id, :integer
    add_column :contacts, :contact_entity_type, :string
  end
end
