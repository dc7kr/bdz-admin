require 'rails_helper'

RSpec.describe "magazine_samplings/show", :type => :view do
  before(:each) do
    @magazine_sampling = assign(:magazine_sampling, MagazineSampling.create!(
      :count => 1,
      :address_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
