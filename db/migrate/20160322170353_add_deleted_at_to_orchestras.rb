class AddDeletedAtToOrchestras < ActiveRecord::Migration[4.2]
  def change
    add_column :orchestras, :deleted_at, :datetime
    add_index :orchestras, :deleted_at
  end
end
