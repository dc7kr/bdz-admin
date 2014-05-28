class AddPickupToEventCards < ActiveRecord::Migration
  def change
    add_column :event_cards, :pickup, :boolean, :default=false
  end
end
