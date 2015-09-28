require 'rails_helper'

RSpec.describe "person_members/index", :type => :view do
  before(:each) do
    assign(:person_members, [
      PersonMember.create!(
        :mitgliedsnummer => 1,
        :anrede => "Anrede",
        :vorname => "Vorname",
        :nachname => "Nachname",
        :strasse => "Strasse",
        :land => "Land",
        :plz => "Plz",
        :Ort => "Ort",
        :telefonPrivat => "Telefon Privat",
        :telefonDienstl => "Telefon Dienstl",
        :telefax => "Telefax",
        :za => "Za",
        :konto => 2,
        :blz => 3,
        :zahler => "Zahler",
        :lv => 4,
        :beitragsart => 5,
        :bemerkung => "Bemerkung",
        :zeitungen => 6,
        :beitrag => "9.99",
        :zusatzzeitung => 7,
        :eMail => "E Mail",
        :lastschriftErfasst => false,
        :rechnungsDruck => false,
        :jahreszahl => 8
      ),
      PersonMember.create!(
        :mitgliedsnummer => 1,
        :anrede => "Anrede",
        :vorname => "Vorname",
        :nachname => "Nachname",
        :strasse => "Strasse",
        :land => "Land",
        :plz => "Plz",
        :Ort => "Ort",
        :telefonPrivat => "Telefon Privat",
        :telefonDienstl => "Telefon Dienstl",
        :telefax => "Telefax",
        :za => "Za",
        :konto => 2,
        :blz => 3,
        :zahler => "Zahler",
        :lv => 4,
        :beitragsart => 5,
        :bemerkung => "Bemerkung",
        :zeitungen => 6,
        :beitrag => "9.99",
        :zusatzzeitung => 7,
        :eMail => "E Mail",
        :lastschriftErfasst => false,
        :rechnungsDruck => false,
        :jahreszahl => 8
      )
    ])
  end

  it "renders a list of person_members" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Anrede".to_s, :count => 2
    assert_select "tr>td", :text => "Vorname".to_s, :count => 2
    assert_select "tr>td", :text => "Nachname".to_s, :count => 2
    assert_select "tr>td", :text => "Strasse".to_s, :count => 2
    assert_select "tr>td", :text => "Land".to_s, :count => 2
    assert_select "tr>td", :text => "Plz".to_s, :count => 2
    assert_select "tr>td", :text => "Ort".to_s, :count => 2
    assert_select "tr>td", :text => "Telefon Privat".to_s, :count => 2
    assert_select "tr>td", :text => "Telefon Dienstl".to_s, :count => 2
    assert_select "tr>td", :text => "Telefax".to_s, :count => 2
    assert_select "tr>td", :text => "Za".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Zahler".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Bemerkung".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "E Mail".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
  end
end
