class AddPublishToOrchestras < ActiveRecord::Migration[4.2]
  def change
    add_column :orchestras, :publish_url, :boolean, :default => true
    add_column :orchestras, :publish_address, :boolean, :default => false
  end
end
