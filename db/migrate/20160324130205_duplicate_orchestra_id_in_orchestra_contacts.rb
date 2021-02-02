class DuplicateOrchestraIdInOrchestraContacts < ActiveRecord::Migration[4.2]
  def change
    rename_column :orchestra_contacts, :orchestra_id, :orchestra_id_old
    add_column :orchestra_contacts, :orchestra_id, :integer
  end
end
