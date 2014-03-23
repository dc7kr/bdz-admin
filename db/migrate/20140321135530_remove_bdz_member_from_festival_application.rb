class RemoveBdzMemberFromFestivalApplication < ActiveRecord::Migration
  def up
    remove_column :festival_applications, :bdz_member
  end

  def down
    add_column :festival_applications, :bdz_member, :boolean
  end
end
