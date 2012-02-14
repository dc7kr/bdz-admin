class MemberAccountBooking < ActiveRecord::Base
	set_table_name "member_acct_booking"
	belongs_to :member
end

