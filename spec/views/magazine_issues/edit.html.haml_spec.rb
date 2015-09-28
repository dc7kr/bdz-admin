require 'rails_helper'

RSpec.describe "magazine_issues/edit", :type => :view do
  before(:each) do
    @magazine_issue = assign(:magazine_issue, MagazineIssue.create!(
      :year => 1,
      :number => 1
    ))
  end

  it "renders the edit magazine_issue form" do
    render

    assert_select "form[action=?][method=?]", magazine_issue_path(@magazine_issue), "post" do

      assert_select "input#magazine_issue_year[name=?]", "magazine_issue[year]"

      assert_select "input#magazine_issue_number[name=?]", "magazine_issue[number]"
    end
  end
end
