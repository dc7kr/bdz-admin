class DuplicateOrchIdInOrchestraMembers< ActiveRecord::Migration
  def change
    rename_column :orchestra_members, :orchestra_id, :orchestra_id_old
    add_column :orchestra_members, :orchestra_id, :integer
  end
end
