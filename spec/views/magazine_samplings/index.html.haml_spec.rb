require 'rails_helper'

RSpec.describe 'magazine_samplings/index', type: :view do
  before(:each) do
    assign(:magazine_samplings, [
             MagazineSampling.create!(
               count: 1,
               address_id: 2
             ),
             MagazineSampling.create!(
               count: 1,
               address_id: 2
             )
           ])
  end

  it 'renders a list of magazine_samplings' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
