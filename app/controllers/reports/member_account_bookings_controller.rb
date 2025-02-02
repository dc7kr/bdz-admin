module Reports
  class MemberAccountBookingsController < AuthenticatedController
    def index
      @bookings = MemberAccountBooking.includes(:member).where("booking_type = 'L'")
    end
  end
end
