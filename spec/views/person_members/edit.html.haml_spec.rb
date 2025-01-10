require 'rails_helper'

RSpec.describe 'person_members/edit', type: :view do
  before(:each) do
    @person_member = assign(:person_member, PersonMember.create!(
                                              mitgliedsnummer: 1,
                                              anrede: 'MyString',
                                              vorname: 'MyString',
                                              nachname: 'MyString',
                                              strasse: 'MyString',
                                              land: 'MyString',
                                              plz: 'MyString',
                                              Ort: 'MyString',
                                              telefonPrivat: 'MyString',
                                              telefonDienstl: 'MyString',
                                              telefax: 'MyString',
                                              za: 'MyString',
                                              konto: 1,
                                              blz: 1,
                                              zahler: 'MyString',
                                              lv: 1,
                                              beitragsart: 1,
                                              bemerkung: 'MyString',
                                              zeitungen: 1,
                                              beitrag: '9.99',
                                              zusatzzeitung: 1,
                                              eMail: 'MyString',
                                              lastschriftErfasst: false,
                                              rechnungsDruck: false,
                                              jahreszahl: 1
                                            ))
  end

  it 'renders the edit person_member form' do
    render

    assert_select 'form[action=?][method=?]', person_member_path(@person_member), 'post' do
      assert_select 'input#person_member_mitgliedsnummer[name=?]', 'person_member[mitgliedsnummer]'

      assert_select 'input#person_member_anrede[name=?]', 'person_member[anrede]'

      assert_select 'input#person_member_vorname[name=?]', 'person_member[vorname]'

      assert_select 'input#person_member_nachname[name=?]', 'person_member[nachname]'

      assert_select 'input#person_member_strasse[name=?]', 'person_member[strasse]'

      assert_select 'input#person_member_land[name=?]', 'person_member[land]'

      assert_select 'input#person_member_plz[name=?]', 'person_member[plz]'

      assert_select 'input#person_member_Ort[name=?]', 'person_member[Ort]'

      assert_select 'input#person_member_telefonPrivat[name=?]', 'person_member[telefonPrivat]'

      assert_select 'input#person_member_telefonDienstl[name=?]', 'person_member[telefonDienstl]'

      assert_select 'input#person_member_telefax[name=?]', 'person_member[telefax]'

      assert_select 'input#person_member_za[name=?]', 'person_member[za]'

      assert_select 'input#person_member_konto[name=?]', 'person_member[konto]'

      assert_select 'input#person_member_blz[name=?]', 'person_member[blz]'

      assert_select 'input#person_member_zahler[name=?]', 'person_member[zahler]'

      assert_select 'input#person_member_lv[name=?]', 'person_member[lv]'

      assert_select 'input#person_member_beitragsart[name=?]', 'person_member[beitragsart]'

      assert_select 'input#person_member_bemerkung[name=?]', 'person_member[bemerkung]'

      assert_select 'input#person_member_zeitungen[name=?]', 'person_member[zeitungen]'

      assert_select 'input#person_member_beitrag[name=?]', 'person_member[beitrag]'

      assert_select 'input#person_member_zusatzzeitung[name=?]', 'person_member[zusatzzeitung]'

      assert_select 'input#person_member_eMail[name=?]', 'person_member[eMail]'

      assert_select 'input#person_member_lastschriftErfasst[name=?]', 'person_member[lastschriftErfasst]'

      assert_select 'input#person_member_rechnungsDruck[name=?]', 'person_member[rechnungsDruck]'

      assert_select 'input#person_member_jahreszahl[name=?]', 'person_member[jahreszahl]'
    end
  end
end
