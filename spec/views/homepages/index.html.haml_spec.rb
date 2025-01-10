require 'rails_helper'

RSpec.describe 'homepages/index', type: :view do
  before(:each) do
    assign(:homepages, [
             Homepage.create!(
               abbrev: 'Abbrev',
               mitglnr: 'Mitglnr',
               name: 'Name',
               kontakt: 'Kontakt',
               proben: 'Proben',
               descr: 'Descr',
               redir_url: 'Redir Url'
             ),
             Homepage.create!(
               abbrev: 'Abbrev',
               mitglnr: 'Mitglnr',
               name: 'Name',
               kontakt: 'Kontakt',
               proben: 'Proben',
               descr: 'Descr',
               redir_url: 'Redir Url'
             )
           ])
  end

  it 'renders a list of homepages' do
    render
    assert_select 'tr>td', text: 'Abbrev'.to_s, count: 2
    assert_select 'tr>td', text: 'Mitglnr'.to_s, count: 2
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Kontakt'.to_s, count: 2
    assert_select 'tr>td', text: 'Proben'.to_s, count: 2
    assert_select 'tr>td', text: 'Descr'.to_s, count: 2
    assert_select 'tr>td', text: 'Redir Url'.to_s, count: 2
  end
end
