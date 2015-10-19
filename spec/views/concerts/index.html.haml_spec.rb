require 'rails_helper'

RSpec.describe "concerts/index", :type => :view do
  before(:each) do
    assign(:concerts, [
      Concert.create!(
        :token => "Token",
        :stadt => "Stadt",
        :titel => "Titel",
        :ort => "Ort",
        :festival_id => 1,
        :interpret => "Interpret",
        :homepage => "Homepage",
        :comment => "Comment",
        :bland_id => 2,
        :land_id => 3,
        :email => "Email",
        :url => "Url",
        :eintritt => 1.5,
        :owner => 4,
        :visible => false,
        :orchestra_id => 5,
        :uid => "Uid",
        :country_code => "Country Code",
        :mglnr => 6
      ),
      Concert.create!(
        :token => "Token",
        :stadt => "Stadt",
        :titel => "Titel",
        :ort => "Ort",
        :festival_id => 1,
        :interpret => "Interpret",
        :homepage => "Homepage",
        :comment => "Comment",
        :bland_id => 2,
        :land_id => 3,
        :email => "Email",
        :url => "Url",
        :eintritt => 1.5,
        :owner => 4,
        :visible => false,
        :orchestra_id => 5,
        :uid => "Uid",
        :country_code => "Country Code",
        :mglnr => 6
      )
    ])
  end

  it "renders a list of concerts" do
    render
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => "Stadt".to_s, :count => 2
    assert_select "tr>td", :text => "Titel".to_s, :count => 2
    assert_select "tr>td", :text => "Ort".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Interpret".to_s, :count => 2
    assert_select "tr>td", :text => "Homepage".to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
