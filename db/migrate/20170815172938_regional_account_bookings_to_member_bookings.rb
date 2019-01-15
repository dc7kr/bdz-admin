class RegionalAccountBookingsToMemberBookings < ActiveRecord::Migration
  def change
    RegionalOrganizationBooking.all.each do |rb|
      lv = rb.regional_organization
      member = lv.member

      mb = MemberAccountBooking.new

      mb.booking_year = rb.booking_year
      mb.booking_type = rb.booking_type
      mb.booking_mode  = rb.booking_mode
      mb.booking_date = rb.booking_date 
      mb.booking_txt  = rb.booking_txt  
      mb.filename = rb.filename
      mb.amount = rb.amount
      mb.member = member

      mb.save
    end
  end
end
