module MemberAccountBookingsHelper
  def booking_type_options
    MemberAccountBooking.booking_types.map do |type|
      [ t("member_account_bookings.booking_types.#{type}"), type ]
    end
  end
end
