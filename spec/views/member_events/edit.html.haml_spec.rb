require 'rails_helper'

RSpec.describe 'member_events/edit', type: :view do
  before(:each) do
    @member_event = assign(:member_event, MemberEvent.create!(
                                            event_type: 'MyString',
                                            event_id: 'MyString',
                                            member_id: 1,
                                            comment: 'MyString',
                                            filename: 'MyString'
                                          ))
  end

  it 'renders the edit member_event form' do
    render

    assert_select 'form[action=?][method=?]', member_event_path(@member_event), 'post' do
      assert_select 'input#member_event_event_type[name=?]', 'member_event[event_type]'

      assert_select 'input#member_event_event_id[name=?]', 'member_event[event_id]'

      assert_select 'input#member_event_member_id[name=?]', 'member_event[member_id]'

      assert_select 'input#member_event_comment[name=?]', 'member_event[comment]'

      assert_select 'input#member_event_filename[name=?]', 'member_event[filename]'
    end
  end
end
