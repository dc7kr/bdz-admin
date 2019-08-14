module MemberAccountBookingsHelper

  def booking_type_options
    retval = Array.new 

    MemberAccountBooking.booking_types.each do |type|
      retval << [ t('member_account_booking.booking_type_'+type), type]
    end

    retval
  end
end
