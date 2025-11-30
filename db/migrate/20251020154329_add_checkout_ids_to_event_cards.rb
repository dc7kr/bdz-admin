class AddCheckoutIdsToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :checkout_reference, :string
    add_column :event_cards, :checkout_id, :string
  end
end
