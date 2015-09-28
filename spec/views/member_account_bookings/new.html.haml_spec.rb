require 'rails_helper'

RSpec.describe "member_account_bookings/new", :type => :view do
  before(:each) do
    assign(:member_account_booking, MemberAccountBooking.new(
      :member_id => 1,
      :integer => 1,
      :booking_type => "MyString",
      :string => "MyString",
      :booking_year => 1,
      :booking_mode => "MyString",
      :booking_txt => "MyString",
      :filename => "MyString",
      :amount => 1.5,
      :ref_booking_id => 1
    ))
  end

  it "renders new member_account_booking form" do
    render

    assert_select "form[action=?][method=?]", member_account_bookings_path, "post" do

      assert_select "input#member_account_booking_member_id[name=?]", "member_account_booking[member_id]"

      assert_select "input#member_account_booking_integer[name=?]", "member_account_booking[integer]"

      assert_select "input#member_account_booking_booking_type[name=?]", "member_account_booking[booking_type]"

      assert_select "input#member_account_booking_string[name=?]", "member_account_booking[string]"

      assert_select "input#member_account_booking_booking_year[name=?]", "member_account_booking[booking_year]"

      assert_select "input#member_account_booking_booking_mode[name=?]", "member_account_booking[booking_mode]"

      assert_select "input#member_account_booking_booking_txt[name=?]", "member_account_booking[booking_txt]"

      assert_select "input#member_account_booking_filename[name=?]", "member_account_booking[filename]"

      assert_select "input#member_account_booking_amount[name=?]", "member_account_booking[amount]"

      assert_select "input#member_account_booking_ref_booking_id[name=?]", "member_account_booking[ref_booking_id]"
    end
  end
end
