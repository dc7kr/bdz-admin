class AddPermissionToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :permission, :boolean
  end
end
