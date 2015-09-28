require 'rails_helper'

RSpec.describe "members/show", :type => :view do
  before(:each) do
    @member = assign(:member, Member.create!(
      :subtype => "Subtype",
      :regional_organization_id => 1,
      :mglnr => 2,
      :anrede => "Anrede",
      :vorname => "Vorname",
      :name => "Name",
      :strasse => "Strasse",
      :plz => "Plz",
      :ort => "Ort",
      :email => "Email",
      :za => "Za",
      :konto => 3,
      :blz => "Blz",
      :zahler => "Zahler",
      :telefon => "Telefon",
      :fax => "Fax",
      :bic => "Bic",
      :iban => "Iban",
      :country_code => "Country Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Subtype/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Anrede/)
    expect(rendered).to match(/Vorname/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Strasse/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Za/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Blz/)
    expect(rendered).to match(/Zahler/)
    expect(rendered).to match(/Telefon/)
    expect(rendered).to match(/Fax/)
    expect(rendered).to match(/Bic/)
    expect(rendered).to match(/Iban/)
    expect(rendered).to match(/Country Code/)
  end
end
