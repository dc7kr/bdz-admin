module MemberAccountBookingsHelper
  def booking_type_options
    MemberAccountBooking.booking_types.map do |type|
      [t("member_account_booking.booking_type_#{type}"), type]
    end
  end
end
