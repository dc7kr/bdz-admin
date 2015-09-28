require 'rails_helper'

RSpec.describe "member_events/index", :type => :view do
  before(:each) do
    assign(:member_events, [
      MemberEvent.create!(
        :event_type => "Event Type",
        :event_id => "Event",
        :member_id => 1,
        :comment => "Comment",
        :filename => "Filename"
      ),
      MemberEvent.create!(
        :event_type => "Event Type",
        :event_id => "Event",
        :member_id => 1,
        :comment => "Comment",
        :filename => "Filename"
      )
    ])
  end

  it "renders a list of member_events" do
    render
    assert_select "tr>td", :text => "Event Type".to_s, :count => 2
    assert_select "tr>td", :text => "Event".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
  end
end
