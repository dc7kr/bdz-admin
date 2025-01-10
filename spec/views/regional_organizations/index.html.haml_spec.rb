require 'rails_helper'

RSpec.describe 'regional_organizations/index', type: :view do
  before(:each) do
    assign(:regional_organizations, [
             RegionalOrganization.create!(
               nummer: 1,
               name: 'Name',
               subname: 'Subname',
               homepage: 'Homepage',
               jugendurl: 'Jugendurl',
               iban: 'Iban',
               bic: 'Bic'
             ),
             RegionalOrganization.create!(
               nummer: 1,
               name: 'Name',
               subname: 'Subname',
               homepage: 'Homepage',
               jugendurl: 'Jugendurl',
               iban: 'Iban',
               bic: 'Bic'
             )
           ])
  end

  it 'renders a list of regional_organizations' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Subname'.to_s, count: 2
    assert_select 'tr>td', text: 'Homepage'.to_s, count: 2
    assert_select 'tr>td', text: 'Jugendurl'.to_s, count: 2
    assert_select 'tr>td', text: 'Iban'.to_s, count: 2
    assert_select 'tr>td', text: 'Bic'.to_s, count: 2
  end
end
