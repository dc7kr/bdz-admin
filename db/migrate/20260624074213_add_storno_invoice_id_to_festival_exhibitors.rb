class AddStornoInvoiceIdToFestivalExhibitors < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_exhibitors, :storno_invoice_id, :string
  end
end
