class MemberAccountBooking < ActiveRecord::Base
	set_table_name "member_acct_booking"
	belongs_to :member

	def has_attachment?
		filename != nil and filename.length()>0
    end

	def self.newInvoice(txt,amount,mglnrStr)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_year = Time.now.year
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type='B'
		@booking.amount=amount

		@dateprefix = Time.now.strftime '%Y%m%d'
		
		@booking.filename = @dateprefix+"_rechnung"+mglnrStr+".pdf"

		return @booking
	end
	def self.newWithdrawal(txt,amount)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_year = Time.now.year
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type='L'
		@booking.amount=amount

		return @booking
	end

    def self.nonZeroBalance
      where('sum(amount)<0').group(:member_id)
    end

    comma :gema do
    end
end

