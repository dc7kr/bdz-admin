class AddPolymorphismToMember < ActiveRecord::Migration
  def change
    add_column :members, :member_entity_type, :string
    add_column :members, :member_entity_id, :integer
  end
end
