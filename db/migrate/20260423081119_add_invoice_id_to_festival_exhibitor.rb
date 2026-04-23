class AddInvoiceIdToFestivalExhibitor < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_exhibitors, :invoice_id, :string
  end
end
