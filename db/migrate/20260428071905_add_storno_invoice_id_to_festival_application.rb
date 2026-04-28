class AddStornoInvoiceIdToFestivalApplication < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_applications, :storno_invoice_id, :string
  end
end
