class DuplicateOrchIdInOrchestraMembers< ActiveRecord::Migration[4.2]
  def change
    rename_column :orchestra_members, :orchestra_id, :orchestra_id_old
    add_column :orchestra_members, :orchestra_id, :integer
  end
end
