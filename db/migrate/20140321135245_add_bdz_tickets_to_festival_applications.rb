class AddBdzTicketsToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :bdz_tickets, :integer
    add_column :festival_applications, :bdz_tickets_red, :integer
  end
end
