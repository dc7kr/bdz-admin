class AddStornoInvoiceIdToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :storno_invoice_id, :string
  end
end
