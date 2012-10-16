class Reports::MemberAccountBookingsController < AuthenticatedController

	def index
		@bookings = MemberAccountBooking.includes(:member).where("booking_type = 'L'")
	end

end
