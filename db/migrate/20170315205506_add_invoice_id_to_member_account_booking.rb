class AddInvoiceIdToMemberAccountBooking < ActiveRecord::Migration
  def change
    add_column :member_account_bookings, :invoice_id, :string
  end
end
