require 'rails_helper'

RSpec.describe 'member_account_bookings/show', type: :view do
  before(:each) do
    @member_account_booking = assign(:member_account_booking, MemberAccountBooking.create!(
                                                                member_id: 1,
                                                                integer: 2,
                                                                booking_type: 'Booking Type',
                                                                string: 'String',
                                                                booking_year: 3,
                                                                booking_mode: 'Booking Mode',
                                                                booking_txt: 'Booking Txt',
                                                                filename: 'Filename',
                                                                amount: 1.5,
                                                                ref_booking_id: 4
                                                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Booking Type/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Booking Mode/)
    expect(rendered).to match(/Booking Txt/)
    expect(rendered).to match(/Filename/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/4/)
  end
end
