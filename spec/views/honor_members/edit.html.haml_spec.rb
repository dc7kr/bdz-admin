require 'rails_helper'

RSpec.describe "honor_members/edit", :type => :view do
  before(:each) do
    @honor_member = assign(:honor_member, HonorMember.create!(
      :nr => 1,
      :vorname => "MyString",
      :name => "MyString",
      :ort => "MyString",
      :honorType => "MyString"
    ))
  end

  it "renders the edit honor_member form" do
    render

    assert_select "form[action=?][method=?]", honor_member_path(@honor_member), "post" do

      assert_select "input#honor_member_nr[name=?]", "honor_member[nr]"

      assert_select "input#honor_member_vorname[name=?]", "honor_member[vorname]"

      assert_select "input#honor_member_name[name=?]", "honor_member[name]"

      assert_select "input#honor_member_ort[name=?]", "honor_member[ort]"

      assert_select "input#honor_member_honorType[name=?]", "honor_member[honorType]"
    end
  end
end
