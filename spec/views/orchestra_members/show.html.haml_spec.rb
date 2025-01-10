require 'rails_helper'

RSpec.describe 'orchestra_members/show', type: :view do
  before(:each) do
    @orchestra_member = assign(:orchestra_member, OrchestraMember.create!(
                                                    report_sheet_id: 1,
                                                    orchestra_id: 2,
                                                    token: 'Token',
                                                    admin_flag: false
                                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/false/)
  end
end
