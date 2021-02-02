class AddPickupToEventCards < ActiveRecord::Migration[4.2]
  def change
    add_column :event_cards, :pickup, :boolean, :default=>false
  end
end
