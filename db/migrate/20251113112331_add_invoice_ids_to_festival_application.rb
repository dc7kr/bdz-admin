class AddInvoiceIdsToFestivalApplication < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_applications, :fee_invoice_id, :string
    add_column :festival_applications, :ticket_invoice_id, :string
  end
end
