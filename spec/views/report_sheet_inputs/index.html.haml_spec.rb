require 'rails_helper'

RSpec.describe "report_sheet_inputs/index", :type => :view do
  before(:each) do
    assign(:report_sheet_inputs, [
      ReportSheetInput.create!(
        :report_sheet_id => 1,
        :orchestra_id => 2,
        :token => "Token",
        :admin_flag => false
      ),
      ReportSheetInput.create!(
        :report_sheet_id => 1,
        :orchestra_id => 2,
        :token => "Token",
        :admin_flag => false
      )
    ])
  end

  it "renders a list of report_sheet_inputs" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
