class MemberAccountBooking < ActiveRecord::Base
	set_table_name "member_acct_booking"
	belongs_to :member

	def self.newInvoice(txt,amount)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type='B'
		@booking.amount=amount

		return @booking
	end
	def self.newWithdrawal(txt,amount)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type='L'
		@booking.amount=amount

		return @booking
	end

    def self.nonZeroBalance
      where('sum(amount)<0').group(:member_id)
    end
end

