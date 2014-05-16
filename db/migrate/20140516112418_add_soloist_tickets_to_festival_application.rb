class AddSoloistTicketsToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :soloist_tickets, :integer
  end
end
