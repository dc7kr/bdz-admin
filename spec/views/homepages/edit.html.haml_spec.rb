require 'rails_helper'

RSpec.describe 'homepages/edit', type: :view do
  before(:each) do
    @homepage = assign(:homepage, Homepage.create!(
                                    abbrev: 'MyString',
                                    mitglnr: 'MyString',
                                    name: 'MyString',
                                    kontakt: 'MyString',
                                    proben: 'MyString',
                                    descr: 'MyString',
                                    redir_url: 'MyString'
                                  ))
  end

  it 'renders the edit homepage form' do
    render

    assert_select 'form[action=?][method=?]', homepage_path(@homepage), 'post' do
      assert_select 'input#homepage_abbrev[name=?]', 'homepage[abbrev]'

      assert_select 'input#homepage_mitglnr[name=?]', 'homepage[mitglnr]'

      assert_select 'input#homepage_name[name=?]', 'homepage[name]'

      assert_select 'input#homepage_kontakt[name=?]', 'homepage[kontakt]'

      assert_select 'input#homepage_proben[name=?]', 'homepage[proben]'

      assert_select 'input#homepage_descr[name=?]', 'homepage[descr]'

      assert_select 'input#homepage_redir_url[name=?]', 'homepage[redir_url]'
    end
  end
end
