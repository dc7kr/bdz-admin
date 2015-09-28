require 'rails_helper'

RSpec.describe "magazine_issues/show", :type => :view do
  before(:each) do
    @magazine_issue = assign(:magazine_issue, MagazineIssue.create!(
      :year => 1,
      :number => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
