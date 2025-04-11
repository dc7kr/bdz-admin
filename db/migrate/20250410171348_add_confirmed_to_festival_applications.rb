class AddConfirmedToFestivalApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :festival_applications, :confirmed, :boolean
  end
end
