require 'rails_helper'

RSpec.describe "regional_organizations/show", :type => :view do
  before(:each) do
    @regional_organization = assign(:regional_organization, RegionalOrganization.create!(
      :nummer => 1,
      :name => "Name",
      :subname => "Subname",
      :homepage => "Homepage",
      :jugendurl => "Jugendurl",
      :iban => "Iban",
      :bic => "Bic"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Subname/)
    expect(rendered).to match(/Homepage/)
    expect(rendered).to match(/Jugendurl/)
    expect(rendered).to match(/Iban/)
    expect(rendered).to match(/Bic/)
  end
end
