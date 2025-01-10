require 'rails_helper'

RSpec.describe 'orchestras/index', type: :view do
  before(:each) do
    assign(:orchestras, [
             Orchestra.create!(
               mglnr: 1,
               orchName: 'Orch Name',
               anrede: 'Anrede',
               vorname: 'Vorname',
               nachname: 'Nachname',
               strasse: 'Strasse',
               land: 'Land',
               plz: 'Plz',
               ort: 'Ort',
               telefon: 'Telefon',
               fax: 'Fax',
               za: 'Za',
               konto: 2,
               blz: 3,
               lv_id: 4,
               zw: 'Zw',
               zeitungen: 5,
               gema: 6,
               numBis14: 7,
               num15bis18: 8,
               num19bis27: 9,
               numUeber27: 10,
               sumMitglieder: 11,
               azubi: 12,
               passive: 13,
               beitrag: '9.99',
               unfallversicherung: false,
               meldebogen: false,
               rechnungsDruck: false,
               koopMitglied: false,
               uvBetrag: '9.99',
               rechnungsbetrag: '9.99',
               versaeumniszuschlag: false,
               vZuschlag: '9.99',
               mahngebuehr1: false,
               mahngebuehr2: false,
               mGebuehr1: '9.99',
               mGebuehr2: '9.99',
               bemerkung: 'Bemerkung',
               eMail: 'E Mail',
               url: 'Url',
               lastschriftErfasst: false,
               kuendigungErfasst: false,
               zweitanschrift: 'Zweitanschrift',
               name2: 'Name2',
               dageVER: 14
             ),
             Orchestra.create!(
               mglnr: 1,
               orchName: 'Orch Name',
               anrede: 'Anrede',
               vorname: 'Vorname',
               nachname: 'Nachname',
               strasse: 'Strasse',
               land: 'Land',
               plz: 'Plz',
               ort: 'Ort',
               telefon: 'Telefon',
               fax: 'Fax',
               za: 'Za',
               konto: 2,
               blz: 3,
               lv_id: 4,
               zw: 'Zw',
               zeitungen: 5,
               gema: 6,
               numBis14: 7,
               num15bis18: 8,
               num19bis27: 9,
               numUeber27: 10,
               sumMitglieder: 11,
               azubi: 12,
               passive: 13,
               beitrag: '9.99',
               unfallversicherung: false,
               meldebogen: false,
               rechnungsDruck: false,
               koopMitglied: false,
               uvBetrag: '9.99',
               rechnungsbetrag: '9.99',
               versaeumniszuschlag: false,
               vZuschlag: '9.99',
               mahngebuehr1: false,
               mahngebuehr2: false,
               mGebuehr1: '9.99',
               mGebuehr2: '9.99',
               bemerkung: 'Bemerkung',
               eMail: 'E Mail',
               url: 'Url',
               lastschriftErfasst: false,
               kuendigungErfasst: false,
               zweitanschrift: 'Zweitanschrift',
               name2: 'Name2',
               dageVER: 14
             )
           ])
  end

  it 'renders a list of orchestras' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 'Orch Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Anrede'.to_s, count: 2
    assert_select 'tr>td', text: 'Vorname'.to_s, count: 2
    assert_select 'tr>td', text: 'Nachname'.to_s, count: 2
    assert_select 'tr>td', text: 'Strasse'.to_s, count: 2
    assert_select 'tr>td', text: 'Land'.to_s, count: 2
    assert_select 'tr>td', text: 'Plz'.to_s, count: 2
    assert_select 'tr>td', text: 'Ort'.to_s, count: 2
    assert_select 'tr>td', text: 'Telefon'.to_s, count: 2
    assert_select 'tr>td', text: 'Fax'.to_s, count: 2
    assert_select 'tr>td', text: 'Za'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 3.to_s, count: 2
    assert_select 'tr>td', text: 4.to_s, count: 2
    assert_select 'tr>td', text: 'Zw'.to_s, count: 2
    assert_select 'tr>td', text: 5.to_s, count: 2
    assert_select 'tr>td', text: 6.to_s, count: 2
    assert_select 'tr>td', text: 7.to_s, count: 2
    assert_select 'tr>td', text: 8.to_s, count: 2
    assert_select 'tr>td', text: 9.to_s, count: 2
    assert_select 'tr>td', text: 10.to_s, count: 2
    assert_select 'tr>td', text: 11.to_s, count: 2
    assert_select 'tr>td', text: 12.to_s, count: 2
    assert_select 'tr>td', text: 13.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: '9.99'.to_s, count: 2
    assert_select 'tr>td', text: 'Bemerkung'.to_s, count: 2
    assert_select 'tr>td', text: 'E Mail'.to_s, count: 2
    assert_select 'tr>td', text: 'Url'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'Zweitanschrift'.to_s, count: 2
    assert_select 'tr>td', text: 'Name2'.to_s, count: 2
    assert_select 'tr>td', text: 14.to_s, count: 2
  end
end
