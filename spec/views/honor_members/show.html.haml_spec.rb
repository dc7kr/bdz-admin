require 'rails_helper'

RSpec.describe "honor_members/show", :type => :view do
  before(:each) do
    @honor_member = assign(:honor_member, HonorMember.create!(
      :nr => 1,
      :vorname => "Vorname",
      :name => "Name",
      :ort => "Ort",
      :honorType => "Honor Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Vorname/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Honor Type/)
  end
end
