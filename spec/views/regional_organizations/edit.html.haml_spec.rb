require 'rails_helper'

RSpec.describe "regional_organizations/edit", :type => :view do
  before(:each) do
    @regional_organization = assign(:regional_organization, RegionalOrganization.create!(
      :nummer => 1,
      :name => "MyString",
      :subname => "MyString",
      :homepage => "MyString",
      :jugend_url => "MyString",
      :iban => "MyString",
      :bic => "MyString"
    ))
  end

  it "renders the edit regional_organization form" do
    render

    assert_select "form[action=?][method=?]", regional_organization_path(@regional_organization), "post" do

      assert_select "input#regional_organization_nummer[name=?]", "regional_organization[nummer]"

      assert_select "input#regional_organization_name[name=?]", "regional_organization[name]"

      assert_select "input#regional_organization_subname[name=?]", "regional_organization[subname]"

      assert_select "input#regional_organization_homepage[name=?]", "regional_organization[homepage]"

      assert_select "input#regional_organization_jugendurl[name=?]", "regional_organization[jugendurl]"

      assert_select "input#regional_organization_iban[name=?]", "regional_organization[iban]"

      assert_select "input#regional_organization_bic[name=?]", "regional_organization[bic]"
    end
  end
end
