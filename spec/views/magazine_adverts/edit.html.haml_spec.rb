require 'rails_helper'

RSpec.describe "magazine_adverts/edit", :type => :view do
  before(:each) do
    @magazine_advert = assign(:magazine_advert, MagazineAdvert.create!(
      :advertiser_id => 1,
      :magazine_issue_id => 1
    ))
  end

  it "renders the edit magazine_advert form" do
    render

    assert_select "form[action=?][method=?]", magazine_advert_path(@magazine_advert), "post" do

      assert_select "input#magazine_advert_advertiser_id[name=?]", "magazine_advert[advertiser_id]"

      assert_select "input#magazine_advert_magazine_issue_id[name=?]", "magazine_advert[magazine_issue_id]"
    end
  end
end
