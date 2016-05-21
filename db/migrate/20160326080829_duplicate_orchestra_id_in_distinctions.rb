class DuplicateOrchestraIdInDistinctions < ActiveRecord::Migration
  def change
    rename_column :distinctions, :orchestra_id, :orchestra_id_old
    add_column :distinctions, :orchestra_id, :integer
  end
end
