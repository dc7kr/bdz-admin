require 'rails_helper'

RSpec.describe "tariffs/new", :type => :view do
  before(:each) do
    assign(:tariff, Tariff.new(
      :tariff_type => 1,
      :description => "MyString",
      :amount => 1.5
    ))
  end

  it "renders new tariff form" do
    render

    assert_select "form[action=?][method=?]", tariffs_path, "post" do

      assert_select "input#tariff_tariff_type[name=?]", "tariff[tariff_type]"

      assert_select "input#tariff_description[name=?]", "tariff[description]"

      assert_select "input#tariff_amount[name=?]", "tariff[amount]"
    end
  end
end
