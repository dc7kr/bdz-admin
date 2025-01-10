require 'rails_helper'

RSpec.describe 'regional_organization_bookings/show', type: :view do
  before(:each) do
    @regional_organization_booking = assign(:regional_organization_booking, RegionalOrganizationBooking.create!(
                                                                              regional_organization_id: 1,
                                                                              booking_type: 'Booking Type',
                                                                              booking_year: 2,
                                                                              booking_mode: 'Booking Mode',
                                                                              booking_txt: 'Booking Txt',
                                                                              filename: 'Filename',
                                                                              amount: 1.5
                                                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Booking Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Booking Mode/)
    expect(rendered).to match(/Booking Txt/)
    expect(rendered).to match(/Filename/)
    expect(rendered).to match(/1.5/)
  end
end
