require 'rails_helper'

RSpec.describe 'magazine_issues/index', type: :view do
  before(:each) do
    assign(:magazine_issues, [
             MagazineIssue.create!(
               year: 1,
               number: 2
             ),
             MagazineIssue.create!(
               year: 1,
               number: 2
             )
           ])
  end

  it 'renders a list of magazine_issues' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
