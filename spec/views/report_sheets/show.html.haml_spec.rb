require 'rails_helper'

RSpec.describe "report_sheets/show", :type => :view do
  before(:each) do
    @report_sheet = assign(:report_sheet, ReportSheet.create!(
      :year => 1,
      :orchestra_id => 2,
      :children => 3,
      :teens => 4,
      :youth => 5,
      :adult => 6,
      :uv => 7,
      :zeitungen => 8,
      :gema => 9,
      :azubi => 10,
      :passive => 11,
      :child_ens => 12,
      :youth_ens => 13,
      :adult_ens => 14,
      :senior_ens => 15,
      :chamber_ens => 16,
      :other_ens => 17,
      :token => "Token",
      :azubi_child => 18,
      :azubi_teens => 19,
      :azubi_youth => 20,
      :azubi_adult => 21,
      :azubi_senior => 22,
      :supporters => 23,
      :zo => false,
      :zi_o => false,
      :go => false,
      :oz => false,
      :invoiced => false,
      :comment => "Comment",
      :generated => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/15/)
    expect(rendered).to match(/16/)
    expect(rendered).to match(/17/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/18/)
    expect(rendered).to match(/19/)
    expect(rendered).to match(/20/)
    expect(rendered).to match(/21/)
    expect(rendered).to match(/22/)
    expect(rendered).to match(/23/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/false/)
  end
end
