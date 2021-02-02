class AddReferencedBookingToMemberAccountBookings < ActiveRecord::Migration[4.2]
  def change
    add_column :member_account_bookings, :ref_booking_id, :integer
	add_index  :member_account_bookings, :ref_booking_id

  end
end
