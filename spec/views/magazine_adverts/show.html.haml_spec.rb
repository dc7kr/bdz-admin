require 'rails_helper'

RSpec.describe "magazine_adverts/show", :type => :view do
  before(:each) do
    @magazine_advert = assign(:magazine_advert, MagazineAdvert.create!(
      :advertiser_id => 1,
      :magazine_issue_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
