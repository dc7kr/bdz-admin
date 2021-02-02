class AddDeceasedToHonorMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :honor_members, :deceased, :boolean
  end
end
