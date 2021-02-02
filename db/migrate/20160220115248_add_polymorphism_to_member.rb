class AddPolymorphismToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :member_entity_type, :string
    add_column :members, :member_entity_id, :integer
  end
end
