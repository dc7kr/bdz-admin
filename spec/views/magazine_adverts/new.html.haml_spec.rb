require 'rails_helper'

RSpec.describe 'magazine_adverts/new', type: :view do
  before(:each) do
    assign(:magazine_advert, MagazineAdvert.new(
                               advertiser_id: 1,
                               magazine_issue_id: 1
                             ))
  end

  it 'renders new magazine_advert form' do
    render

    assert_select 'form[action=?][method=?]', magazine_adverts_path, 'post' do
      assert_select 'input#magazine_advert_advertiser_id[name=?]', 'magazine_advert[advertiser_id]'

      assert_select 'input#magazine_advert_magazine_issue_id[name=?]', 'magazine_advert[magazine_issue_id]'
    end
  end
end
