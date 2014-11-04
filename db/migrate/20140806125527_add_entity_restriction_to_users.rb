class AddEntityRestrictionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :entity_class, :string
    add_column :users, :entity_id, :integer
  end
end
