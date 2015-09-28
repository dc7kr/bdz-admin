require 'rails_helper'

RSpec.describe "regional_organization_bookings/new", :type => :view do
  before(:each) do
    assign(:regional_organization_booking, RegionalOrganizationBooking.new(
      :regional_organization_id => 1,
      :booking_type => "MyString",
      :booking_year => 1,
      :booking_mode => "MyString",
      :booking_txt => "MyString",
      :filename => "MyString",
      :amount => 1.5
    ))
  end

  it "renders new regional_organization_booking form" do
    render

    assert_select "form[action=?][method=?]", regional_organization_bookings_path, "post" do

      assert_select "input#regional_organization_booking_regional_organization_id[name=?]", "regional_organization_booking[regional_organization_id]"

      assert_select "input#regional_organization_booking_booking_type[name=?]", "regional_organization_booking[booking_type]"

      assert_select "input#regional_organization_booking_booking_year[name=?]", "regional_organization_booking[booking_year]"

      assert_select "input#regional_organization_booking_booking_mode[name=?]", "regional_organization_booking[booking_mode]"

      assert_select "input#regional_organization_booking_booking_txt[name=?]", "regional_organization_booking[booking_txt]"

      assert_select "input#regional_organization_booking_filename[name=?]", "regional_organization_booking[filename]"

      assert_select "input#regional_organization_booking_amount[name=?]", "regional_organization_booking[amount]"
    end
  end
end
