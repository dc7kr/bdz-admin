class AddPermissionToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :permission, :boolean
  end
end
