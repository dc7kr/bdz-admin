class AddEntityRestrictionToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :entity_class, :string
    add_column :users, :entity_id, :integer
  end
end
