require 'rails_helper'

RSpec.describe 'orchestra_members/index', type: :view do
  before(:each) do
    assign(:orchestra_members, [
             OrchestraMember.create!(
               report_sheet_id: 1,
               orchestra_id: 2,
               token: 'Token',
               admin_flag: false
             ),
             OrchestraMember.create!(
               report_sheet_id: 1,
               orchestra_id: 2,
               token: 'Token',
               admin_flag: false
             )
           ])
  end

  it 'renders a list of orchestra_members' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Token'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
