class AddInvoiceIdToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :invoice_id, :string
  end
end
