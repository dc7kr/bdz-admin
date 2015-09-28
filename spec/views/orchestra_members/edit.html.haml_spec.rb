require 'rails_helper'

RSpec.describe "orchestra_members/edit", :type => :view do
  before(:each) do
    @orchestra_member = assign(:orchestra_member, OrchestraMember.create!(
      :report_sheet_id => 1,
      :orchestra_id => 1,
      :token => "MyString",
      :admin_flag => false
    ))
  end

  it "renders the edit orchestra_member form" do
    render

    assert_select "form[action=?][method=?]", orchestra_member_path(@orchestra_member), "post" do

      assert_select "input#orchestra_member_report_sheet_id[name=?]", "orchestra_member[report_sheet_id]"

      assert_select "input#orchestra_member_orchestra_id[name=?]", "orchestra_member[orchestra_id]"

      assert_select "input#orchestra_member_token[name=?]", "orchestra_member[token]"

      assert_select "input#orchestra_member_admin_flag[name=?]", "orchestra_member[admin_flag]"
    end
  end
end
