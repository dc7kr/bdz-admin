class AddInvoiceIdToDistinction < ActiveRecord::Migration[4.2]
  def change
    add_column :distinctions, :invoice_id, :string
  end
end
