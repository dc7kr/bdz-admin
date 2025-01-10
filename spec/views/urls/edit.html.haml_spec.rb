require 'rails_helper'

RSpec.describe 'urls/edit', type: :view do
  before(:each) do
    @url = assign(:url, Url.create!(
                          category_id: 1,
                          url: 'MyString',
                          titel: 'MyString',
                          descr: 'MyString',
                          sprache: 'MyString',
                          land_id: 1,
                          bland_id: 1,
                          user: 'MyString',
                          email: 'MyString',
                          visible: false,
                          ip: 'MyString',
                          country_code: 'MyString'
                        ))
  end

  it 'renders the edit url form' do
    render

    assert_select 'form[action=?][method=?]', url_path(@url), 'post' do
      assert_select 'input#url_category_id[name=?]', 'url[category_id]'

      assert_select 'input#url_url[name=?]', 'url[url]'

      assert_select 'input#url_titel[name=?]', 'url[titel]'

      assert_select 'input#url_descr[name=?]', 'url[descr]'

      assert_select 'input#url_sprache[name=?]', 'url[sprache]'

      assert_select 'input#url_land_id[name=?]', 'url[land_id]'

      assert_select 'input#url_bland_id[name=?]', 'url[bland_id]'

      assert_select 'input#url_user[name=?]', 'url[user]'

      assert_select 'input#url_email[name=?]', 'url[email]'

      assert_select 'input#url_visible[name=?]', 'url[visible]'

      assert_select 'input#url_ip[name=?]', 'url[ip]'

      assert_select 'input#url_country_code[name=?]', 'url[country_code]'
    end
  end
end
