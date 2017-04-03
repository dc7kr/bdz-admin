class AddInvoiceIdToDistinction < ActiveRecord::Migration
  def change
    add_column :distinctions, :invoice_id, :string
  end
end
