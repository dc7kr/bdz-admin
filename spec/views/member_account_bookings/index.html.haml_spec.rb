require 'rails_helper'

RSpec.describe "member_account_bookings/index", :type => :view do
  before(:each) do
    assign(:member_account_bookings, [
      MemberAccountBooking.create!(
        :member_id => 1,
        :integer => 2,
        :booking_type => "Booking Type",
        :string => "String",
        :booking_year => 3,
        :booking_mode => "Booking Mode",
        :booking_txt => "Booking Txt",
        :filename => "Filename",
        :amount => 1.5,
        :ref_booking_id => 4
      ),
      MemberAccountBooking.create!(
        :member_id => 1,
        :integer => 2,
        :booking_type => "Booking Type",
        :string => "String",
        :booking_year => 3,
        :booking_mode => "Booking Mode",
        :booking_txt => "Booking Txt",
        :filename => "Filename",
        :amount => 1.5,
        :ref_booking_id => 4
      )
    ])
  end

  it "renders a list of member_account_bookings" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Booking Type".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Booking Mode".to_s, :count => 2
    assert_select "tr>td", :text => "Booking Txt".to_s, :count => 2
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
