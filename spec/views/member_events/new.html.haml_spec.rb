require 'rails_helper'

RSpec.describe "member_events/new", :type => :view do
  before(:each) do
    assign(:member_event, MemberEvent.new(
      :event_type => "MyString",
      :event_id => "MyString",
      :member_id => 1,
      :comment => "MyString",
      :filename => "MyString"
    ))
  end

  it "renders new member_event form" do
    render

    assert_select "form[action=?][method=?]", member_events_path, "post" do

      assert_select "input#member_event_event_type[name=?]", "member_event[event_type]"

      assert_select "input#member_event_event_id[name=?]", "member_event[event_id]"

      assert_select "input#member_event_member_id[name=?]", "member_event[member_id]"

      assert_select "input#member_event_comment[name=?]", "member_event[comment]"

      assert_select "input#member_event_filename[name=?]", "member_event[filename]"
    end
  end
end
