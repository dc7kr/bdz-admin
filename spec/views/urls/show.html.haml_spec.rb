require 'rails_helper'

RSpec.describe "urls/show", :type => :view do
  before(:each) do
    @url = assign(:url, Url.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Titel/)
    expect(rendered).to match(/Descr/)
    expect(rendered).to match(/Sprache/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Ip/)
    expect(rendered).to match(/Country Code/)
  end
end
