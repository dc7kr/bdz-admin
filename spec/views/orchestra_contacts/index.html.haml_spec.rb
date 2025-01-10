require 'rails_helper'

RSpec.describe 'orchestra_contacts/index', type: :view do
  before(:each) do
    assign(:orchestra_contacts, [
             OrchestraContact.create!(
               orchestra_id: 1,
               salutation: 'Salutation',
               first_name: 'First Name',
               last_name: 'Last Name',
               street: 'Street',
               zip: 'Zip',
               city: 'City',
               role: 'Role',
               email: 'Email',
               phone: 'Phone',
               country_code: 'Country Code'
             ),
             OrchestraContact.create!(
               orchestra_id: 1,
               salutation: 'Salutation',
               first_name: 'First Name',
               last_name: 'Last Name',
               street: 'Street',
               zip: 'Zip',
               city: 'City',
               role: 'Role',
               email: 'Email',
               phone: 'Phone',
               country_code: 'Country Code'
             )
           ])
  end

  it 'renders a list of orchestra_contacts' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Salutation'.to_s, count: 2
    assert_select 'tr>td', text: 'First Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Last Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Street'.to_s, count: 2
    assert_select 'tr>td', text: 'Zip'.to_s, count: 2
    assert_select 'tr>td', text: 'City'.to_s, count: 2
    assert_select 'tr>td', text: 'Role'.to_s, count: 2
    assert_select 'tr>td', text: 'Email'.to_s, count: 2
    assert_select 'tr>td', text: 'Phone'.to_s, count: 2
    assert_select 'tr>td', text: 'Country Code'.to_s, count: 2
  end
end
