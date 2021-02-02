class AddInvoicedToEventCards < ActiveRecord::Migration[4.2]
  def change
    add_column :event_cards, :invoiced, :boolean, :default => 0
    add_column :event_cards, :payment_received, :boolean, :default => 0
  end
end
