require 'rails_helper'

RSpec.describe "urls/index", :type => :view do
  before(:each) do
    assign(:urls, [
      Url.create!(
        :category_id => 1,
        :url => "Url",
        :titel => "Titel",
        :descr => "Descr",
        :sprache => "Sprache",
        :land_id => 2,
        :bland_id => 3,
        :user => "User",
        :email => "Email",
        :visible => false,
        :ip => "Ip",
        :country_code => "Country Code"
      ),
      Url.create!(
        :category_id => 1,
        :url => "Url",
        :titel => "Titel",
        :descr => "Descr",
        :sprache => "Sprache",
        :land_id => 2,
        :bland_id => 3,
        :user => "User",
        :email => "Email",
        :visible => false,
        :ip => "Ip",
        :country_code => "Country Code"
      )
    ])
  end

  it "renders a list of urls" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Titel".to_s, :count => 2
    assert_select "tr>td", :text => "Descr".to_s, :count => 2
    assert_select "tr>td", :text => "Sprache".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Ip".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
  end
end
