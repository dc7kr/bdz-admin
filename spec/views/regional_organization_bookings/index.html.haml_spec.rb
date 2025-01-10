require 'rails_helper'

RSpec.describe 'regional_organization_bookings/index', type: :view do
  before(:each) do
    assign(:regional_organization_bookings, [
             RegionalOrganizationBooking.create!(
               regional_organization_id: 1,
               booking_type: 'Booking Type',
               booking_year: 2,
               booking_mode: 'Booking Mode',
               booking_txt: 'Booking Txt',
               filename: 'Filename',
               amount: 1.5
             ),
             RegionalOrganizationBooking.create!(
               regional_organization_id: 1,
               booking_type: 'Booking Type',
               booking_year: 2,
               booking_mode: 'Booking Mode',
               booking_txt: 'Booking Txt',
               filename: 'Filename',
               amount: 1.5
             )
           ])
  end

  it 'renders a list of regional_organization_bookings' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Booking Type'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Booking Mode'.to_s, count: 2
    assert_select 'tr>td', text: 'Booking Txt'.to_s, count: 2
    assert_select 'tr>td', text: 'Filename'.to_s, count: 2
    assert_select 'tr>td', text: 1.5.to_s, count: 2
  end
end
