require 'rails_helper'

RSpec.describe "tariffs/index", :type => :view do
  before(:each) do
    assign(:tariffs, [
      Tariff.create!(
        :tariff_type => 1,
        :description => "Description",
        :amount => 1.5
      ),
      Tariff.create!(
        :tariff_type => 1,
        :description => "Description",
        :amount => 1.5
      )
    ])
  end

  it "renders a list of tariffs" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
