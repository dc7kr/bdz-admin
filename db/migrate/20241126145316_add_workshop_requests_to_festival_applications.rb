class AddWorkshopRequestsToFestivalApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :festival_applications, :workshop_request, :text
  end
end
