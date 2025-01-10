require 'rails_helper'

RSpec.describe 'member_events/show', type: :view do
  before(:each) do
    @member_event = assign(:member_event, MemberEvent.create!(
                                            event_type: 'Event Type',
                                            event_id: 'Event',
                                            member_id: 1,
                                            comment: 'Comment',
                                            filename: 'Filename'
                                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Event Type/)
    expect(rendered).to match(/Event/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/Filename/)
  end
end
