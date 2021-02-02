class AddInvoiceIdToMemberAccountBooking < ActiveRecord::Migration[4.2]
  def change
    add_column :member_account_bookings, :invoice_id, :string
  end
end
