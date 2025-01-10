require 'rails_helper'

RSpec.describe 'members/index', type: :view do
  before(:each) do
    assign(:members, [
             Member.create!(
               subtype: 'Subtype',
               regional_organization_id: 1,
               mglnr: 2,
               anrede: 'Anrede',
               vorname: 'Vorname',
               name: 'Name',
               strasse: 'Strasse',
               plz: 'Plz',
               ort: 'Ort',
               email: 'Email',
               za: 'Za',
               konto: 3,
               blz: 'Blz',
               zahler: 'Zahler',
               telefon: 'Telefon',
               fax: 'Fax',
               bic: 'Bic',
               iban: 'Iban',
               country_code: 'Country Code'
             ),
             Member.create!(
               subtype: 'Subtype',
               regional_organization_id: 1,
               mglnr: 2,
               anrede: 'Anrede',
               vorname: 'Vorname',
               name: 'Name',
               strasse: 'Strasse',
               plz: 'Plz',
               ort: 'Ort',
               email: 'Email',
               za: 'Za',
               konto: 3,
               blz: 'Blz',
               zahler: 'Zahler',
               telefon: 'Telefon',
               fax: 'Fax',
               bic: 'Bic',
               iban: 'Iban',
               country_code: 'Country Code'
             )
           ])
  end

  it 'renders a list of members' do
    render
    assert_select 'tr>td', text: 'Subtype'.to_s, count: 2
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Anrede'.to_s, count: 2
    assert_select 'tr>td', text: 'Vorname'.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Strasse'.to_s, count: 2
    assert_select 'tr>td', text: 'Plz'.to_s, count: 2
    assert_select 'tr>td', text: 'Ort'.to_s, count: 2
    assert_select 'tr>td', text: 'Email'.to_s, count: 2
    assert_select 'tr>td', text: 'Za'.to_s, count: 2
    assert_select 'tr>td', text: 3.to_s, count: 2
    assert_select 'tr>td', text: 'Blz'.to_s, count: 2
    assert_select 'tr>td', text: 'Zahler'.to_s, count: 2
    assert_select 'tr>td', text: 'Telefon'.to_s, count: 2
    assert_select 'tr>td', text: 'Fax'.to_s, count: 2
    assert_select 'tr>td', text: 'Bic'.to_s, count: 2
    assert_select 'tr>td', text: 'Iban'.to_s, count: 2
    assert_select 'tr>td', text: 'Country Code'.to_s, count: 2
  end
end
