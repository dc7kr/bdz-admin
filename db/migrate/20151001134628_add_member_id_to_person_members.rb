class AddMemberIdToPersonMembers < ActiveRecord::Migration
  def change
    add_column :person_members, :member_id, :integer
  end
end
