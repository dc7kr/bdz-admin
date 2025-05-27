class RegionalOrganizationBooking < ApplicationRecord
  belongs_to :regional_organization

  def has_attachment?
    !filename.nil? and filename.length.positive?
  end

  def self.new_ct(txt, amount)
    booking = RegionalOrganizationBooking.new
    booking.booking_date = Time.zone.now
    booking.booking_year = Time.zone.now.year
    booking.booking_txt = txt
    booking.booking_mode = "A"
    booking.booking_type = "G"
    booking.amount = amount

    booking
  end
end
