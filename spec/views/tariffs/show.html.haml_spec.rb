require 'rails_helper'

RSpec.describe 'tariffs/show', type: :view do
  before(:each) do
    @tariff = assign(:tariff, Tariff.create!(
                                tariff_type: 1,
                                description: 'Description',
                                amount: 1.5
                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/1.5/)
  end
end
