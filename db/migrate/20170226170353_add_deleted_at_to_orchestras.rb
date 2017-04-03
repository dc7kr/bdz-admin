class AddDeletedAtToOrchestras < ActiveRecord::Migration
  def change
    add_column :orchestras, :deleted_at, :datetime
    add_index :orchestras, :deleted_at
  end
end
