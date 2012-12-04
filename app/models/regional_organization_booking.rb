class RegionalOrganizationBooking < ActiveRecord::Base
  belongs_to :regional_organization

  def has_attachment?
    filename != nil and filename.length()>0
  end

  def self.newCredit(txt,amount)
 	booking=RegionalOrganizationBooking.new
    booking.booking_date = Time.now
    booking.booking_year = Time.now.year
    booking.booking_txt = txt
    booking.booking_mode='A'
    booking.booking_type='G'
    booking.amount=amount

    return booking
  end


end
