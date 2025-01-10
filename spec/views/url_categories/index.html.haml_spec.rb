require 'rails_helper'

RSpec.describe 'url_categories/index', type: :view do
  before(:each) do
    assign(:url_categories, [
             UrlCategory.create!(
               parent_id: 1,
               leaf: false,
               hascountry: false,
               description: 'Description'
             ),
             UrlCategory.create!(
               parent_id: 1,
               leaf: false,
               hascountry: false,
               description: 'Description'
             )
           ])
  end

  it 'renders a list of url_categories' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'Description'.to_s, count: 2
  end
end
