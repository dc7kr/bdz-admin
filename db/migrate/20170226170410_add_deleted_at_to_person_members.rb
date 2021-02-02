class AddDeletedAtToPersonMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :person_members, :deleted_at, :datetime
    add_index :person_members, :deleted_at
  end
end
