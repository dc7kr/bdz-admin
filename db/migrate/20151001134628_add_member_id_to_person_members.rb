class AddMemberIdToPersonMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :person_members, :member_id, :integer
  end
end
