require 'rails_helper'

RSpec.describe 'url_categories/show', type: :view do
  before(:each) do
    @url_category = assign(:url_category, UrlCategory.create!(
                                            parent_id: 1,
                                            leaf: false,
                                            hascountry: false,
                                            description: 'Description'
                                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Description/)
  end
end
