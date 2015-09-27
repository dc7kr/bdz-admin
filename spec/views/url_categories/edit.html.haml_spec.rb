require 'rails_helper'

RSpec.describe "url_categories/edit", :type => :view do
  before(:each) do
    @url_category = assign(:url_category, UrlCategory.create!(
      :parent_id => 1,
      :leaf => false,
      :hascountry => false,
      :description => "MyString"
    ))
  end

  it "renders the edit url_category form" do
    render

    assert_select "form[action=?][method=?]", url_category_path(@url_category), "post" do

      assert_select "input#url_category_parent_id[name=?]", "url_category[parent_id]"

      assert_select "input#url_category_leaf[name=?]", "url_category[leaf]"

      assert_select "input#url_category_hascountry[name=?]", "url_category[hascountry]"

      assert_select "input#url_category_description[name=?]", "url_category[description]"
    end
  end
end
