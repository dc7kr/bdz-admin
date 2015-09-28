require 'rails_helper'

RSpec.describe "magazine_issues/new", :type => :view do
  before(:each) do
    assign(:magazine_issue, MagazineIssue.new(
      :year => 1,
      :number => 1
    ))
  end

  it "renders new magazine_issue form" do
    render

    assert_select "form[action=?][method=?]", magazine_issues_path, "post" do

      assert_select "input#magazine_issue_year[name=?]", "magazine_issue[year]"

      assert_select "input#magazine_issue_number[name=?]", "magazine_issue[number]"
    end
  end
end
