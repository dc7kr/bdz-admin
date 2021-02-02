class AddSoloistTicketsToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :soloist_tickets, :integer
  end
end
