require 'rails_helper'

RSpec.describe 'person_members/show', type: :view do
  before(:each) do
    @person_member = assign(:person_member, PersonMember.create!(
                                              mitgliedsnummer: 1,
                                              anrede: 'Anrede',
                                              vorname: 'Vorname',
                                              nachname: 'Nachname',
                                              strasse: 'Strasse',
                                              land: 'Land',
                                              plz: 'Plz',
                                              Ort: 'Ort',
                                              telefonPrivat: 'Telefon Privat',
                                              telefonDienstl: 'Telefon Dienstl',
                                              telefax: 'Telefax',
                                              za: 'Za',
                                              konto: 2,
                                              blz: 3,
                                              zahler: 'Zahler',
                                              lv: 4,
                                              beitragsart: 5,
                                              bemerkung: 'Bemerkung',
                                              zeitungen: 6,
                                              beitrag: '9.99',
                                              zusatzzeitung: 7,
                                              eMail: 'E Mail',
                                              lastschriftErfasst: false,
                                              rechnungsDruck: false,
                                              jahreszahl: 8
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Anrede/)
    expect(rendered).to match(/Vorname/)
    expect(rendered).to match(/Nachname/)
    expect(rendered).to match(/Strasse/)
    expect(rendered).to match(/Land/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Telefon Privat/)
    expect(rendered).to match(/Telefon Dienstl/)
    expect(rendered).to match(/Telefax/)
    expect(rendered).to match(/Za/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Zahler/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Bemerkung/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/E Mail/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/8/)
  end
end
