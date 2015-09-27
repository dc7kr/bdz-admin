require 'rails_helper'

RSpec.describe "universities/new", :type => :view do
  before(:each) do
    assign(:university, University.new(
      :name => "MyString",
      :institut => "MyString",
      :strasse => "MyString",
      :plz => "MyString",
      :ort => "MyString",
      :land_id => 1,
      :telefon => "MyString",
      :studiengang => "MyString",
      :dozent => "MyString",
      :email => "MyString",
      :homepage => "MyString",
      :country_code => "MyString"
    ))
  end

  it "renders new university form" do
    render

    assert_select "form[action=?][method=?]", universities_path, "post" do

      assert_select "input#university_name[name=?]", "university[name]"

      assert_select "input#university_institut[name=?]", "university[institut]"

      assert_select "input#university_strasse[name=?]", "university[strasse]"

      assert_select "input#university_plz[name=?]", "university[plz]"

      assert_select "input#university_ort[name=?]", "university[ort]"

      assert_select "input#university_land_id[name=?]", "university[land_id]"

      assert_select "input#university_telefon[name=?]", "university[telefon]"

      assert_select "input#university_studiengang[name=?]", "university[studiengang]"

      assert_select "input#university_dozent[name=?]", "university[dozent]"

      assert_select "input#university_email[name=?]", "university[email]"

      assert_select "input#university_homepage[name=?]", "university[homepage]"

      assert_select "input#university_country_code[name=?]", "university[country_code]"
    end
  end
end
