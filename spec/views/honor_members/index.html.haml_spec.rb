require 'rails_helper'

RSpec.describe 'honor_members/index', type: :view do
  before(:each) do
    assign(:honor_members, [
             HonorMember.create!(
               nr: 1,
               vorname: 'Vorname',
               name: 'Name',
               ort: 'Ort',
               honorType: 'Honor Type'
             ),
             HonorMember.create!(
               nr: 1,
               vorname: 'Vorname',
               name: 'Name',
               ort: 'Ort',
               honorType: 'Honor Type'
             )
           ])
  end

  it 'renders a list of honor_members' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Vorname'.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Ort'.to_s, count: 2
    assert_select 'tr>td', text: 'Honor Type'.to_s, count: 2
  end
end
