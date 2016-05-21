class DuplicateOrchestraIdInOrchestraContacts < ActiveRecord::Migration
  def change
    rename_column :orchestra_contacts, :orchestra_id, :orchestra_id_old
    add_column :orchestra_contacts, :orchestra_id, :integer
  end
end
