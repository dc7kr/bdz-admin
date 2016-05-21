class AddDeceasedToHonorMembers < ActiveRecord::Migration
  def change
    add_column :honor_members, :deceased, :boolean
  end
end
