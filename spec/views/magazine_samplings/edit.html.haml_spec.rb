require 'rails_helper'

RSpec.describe "magazine_samplings/edit", :type => :view do
  before(:each) do
    @magazine_sampling = assign(:magazine_sampling, MagazineSampling.create!(
      :count => 1,
      :address_id => 1
    ))
  end

  it "renders the edit magazine_sampling form" do
    render

    assert_select "form[action=?][method=?]", magazine_sampling_path(@magazine_sampling), "post" do

      assert_select "input#magazine_sampling_count[name=?]", "magazine_sampling[count]"

      assert_select "input#magazine_sampling_address_id[name=?]", "magazine_sampling[address_id]"
    end
  end
end
