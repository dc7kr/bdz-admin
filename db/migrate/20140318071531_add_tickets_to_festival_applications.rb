class AddTicketsToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :tickets, :integer
    add_column :festival_applications, :tickets_red, :integer
    add_column :festival_applications, :bdz_member, :boolean
  end
end
