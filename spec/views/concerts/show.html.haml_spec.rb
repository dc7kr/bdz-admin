require 'rails_helper'

RSpec.describe "concerts/show", :type => :view do
  before(:each) do
    @concert = assign(:concert, Concert.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/Stadt/)
    expect(rendered).to match(/Titel/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Interpret/)
    expect(rendered).to match(/Homepage/)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Uid/)
    expect(rendered).to match(/Country Code/)
    expect(rendered).to match(/6/)
  end
end
