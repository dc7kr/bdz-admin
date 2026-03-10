class AddStateToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :order_state, :integer
  end
end
