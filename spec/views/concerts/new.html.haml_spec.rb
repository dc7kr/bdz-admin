require 'rails_helper'

RSpec.describe "concerts/new", :type => :view do
  before(:each) do
    assign(:concert, Concert.new(
      :token => "MyString",
      :stadt => "MyString",
      :titel => "MyString",
      :ort => "MyString",
      :festival_id => 1,
      :interpret => "MyString",
      :homepage => "MyString",
      :comment => "MyString",
      :bland_id => 1,
      :land_id => 1,
      :email => "MyString",
      :url => "MyString",
      :eintritt => 1.5,
      :owner => 1,
      :visible => false,
      :orchestra_id => 1,
      :uid => "MyString",
      :country_code => "MyString",
      :mglnr => 1
    ))
  end

  it "renders new concert form" do
    render

    assert_select "form[action=?][method=?]", concerts_path, "post" do

      assert_select "input#concert_token[name=?]", "concert[token]"

      assert_select "input#concert_stadt[name=?]", "concert[stadt]"

      assert_select "input#concert_titel[name=?]", "concert[titel]"

      assert_select "input#concert_ort[name=?]", "concert[ort]"

      assert_select "input#concert_festival_id[name=?]", "concert[festival_id]"

      assert_select "input#concert_interpret[name=?]", "concert[interpret]"

      assert_select "input#concert_homepage[name=?]", "concert[homepage]"

      assert_select "input#concert_comment[name=?]", "concert[comment]"

      assert_select "input#concert_bland_id[name=?]", "concert[bland_id]"

      assert_select "input#concert_land_id[name=?]", "concert[land_id]"

      assert_select "input#concert_email[name=?]", "concert[email]"

      assert_select "input#concert_url[name=?]", "concert[url]"

      assert_select "input#concert_eintritt[name=?]", "concert[eintritt]"

      assert_select "input#concert_owner[name=?]", "concert[owner]"

      assert_select "input#concert_visible[name=?]", "concert[visible]"

      assert_select "input#concert_orchestra_id[name=?]", "concert[orchestra_id]"

      assert_select "input#concert_uid[name=?]", "concert[uid]"

      assert_select "input#concert_country_code[name=?]", "concert[country_code]"

      assert_select "input#concert_mglnr[name=?]", "concert[mglnr]"
    end
  end
end
