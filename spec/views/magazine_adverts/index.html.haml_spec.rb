require 'rails_helper'

RSpec.describe "magazine_adverts/index", :type => :view do
  before(:each) do
    assign(:magazine_adverts, [
      MagazineAdvert.create!(
        :advertiser_id => 1,
        :magazine_issue_id => 2
      ),
      MagazineAdvert.create!(
        :advertiser_id => 1,
        :magazine_issue_id => 2
      )
    ])
  end

  it "renders a list of magazine_adverts" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
