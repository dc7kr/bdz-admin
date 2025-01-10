require 'rails_helper'

RSpec.describe 'orchestras/show', type: :view do
  before(:each) do
    @orchestra = assign(:orchestra, Orchestra.create!(
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
                                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Orch Name/)
    expect(rendered).to match(/Anrede/)
    expect(rendered).to match(/Vorname/)
    expect(rendered).to match(/Nachname/)
    expect(rendered).to match(/Strasse/)
    expect(rendered).to match(/Land/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Telefon/)
    expect(rendered).to match(/Fax/)
    expect(rendered).to match(/Za/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Zw/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Bemerkung/)
    expect(rendered).to match(/E Mail/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Zweitanschrift/)
    expect(rendered).to match(/Name2/)
    expect(rendered).to match(/14/)
  end
end
