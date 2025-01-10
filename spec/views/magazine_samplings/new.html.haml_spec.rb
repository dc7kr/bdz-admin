require 'rails_helper'

RSpec.describe 'magazine_samplings/new', type: :view do
  before(:each) do
    assign(:magazine_sampling, MagazineSampling.new(
                                 count: 1,
                                 address_id: 1
                               ))
  end

  it 'renders new magazine_sampling form' do
    render

    assert_select 'form[action=?][method=?]', magazine_samplings_path, 'post' do
      assert_select 'input#magazine_sampling_count[name=?]', 'magazine_sampling[count]'

      assert_select 'input#magazine_sampling_address_id[name=?]', 'magazine_sampling[address_id]'
    end
  end
end
