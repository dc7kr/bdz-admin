class AddConcertSoToEventCards < ActiveRecord::Migration
  def change
    add_column :event_cards, :nr_concert_so, :integer,:default => 0, :null => false
    add_column :event_cards, :nr_concert_so_erm, :integer,:default => 0, :null => false
  end
end
