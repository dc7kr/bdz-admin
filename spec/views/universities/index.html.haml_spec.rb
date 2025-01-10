require 'rails_helper'

RSpec.describe 'universities/index', type: :view do
  before(:each) do
    assign(:universities, [
             University.create!(
               name: 'Name',
               institut: 'Institut',
               strasse: 'Strasse',
               plz: 'Plz',
               ort: 'Ort',
               land_id: 1,
               telefon: 'Telefon',
               studiengang: 'Studiengang',
               dozent: 'Dozent',
               email: 'Email',
               homepage: 'Homepage',
               country_code: 'Country Code'
             ),
             University.create!(
               name: 'Name',
               institut: 'Institut',
               strasse: 'Strasse',
               plz: 'Plz',
               ort: 'Ort',
               land_id: 1,
               telefon: 'Telefon',
               studiengang: 'Studiengang',
               dozent: 'Dozent',
               email: 'Email',
               homepage: 'Homepage',
               country_code: 'Country Code'
             )
           ])
  end

  it 'renders a list of universities' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Institut'.to_s, count: 2
    assert_select 'tr>td', text: 'Strasse'.to_s, count: 2
    assert_select 'tr>td', text: 'Plz'.to_s, count: 2
    assert_select 'tr>td', text: 'Ort'.to_s, count: 2
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Telefon'.to_s, count: 2
    assert_select 'tr>td', text: 'Studiengang'.to_s, count: 2
    assert_select 'tr>td', text: 'Dozent'.to_s, count: 2
    assert_select 'tr>td', text: 'Email'.to_s, count: 2
    assert_select 'tr>td', text: 'Homepage'.to_s, count: 2
    assert_select 'tr>td', text: 'Country Code'.to_s, count: 2
  end
end
