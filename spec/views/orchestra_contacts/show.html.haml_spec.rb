require 'rails_helper'

RSpec.describe 'orchestra_contacts/show', type: :view do
  before(:each) do
    @orchestra_contact = assign(:orchestra_contact, OrchestraContact.create!(
                                                      orchestra_id: 1,
                                                      salutation: 'Salutation',
                                                      first_name: 'First Name',
                                                      last_name: 'Last Name',
                                                      street: 'Street',
                                                      zip: 'Zip',
                                                      city: 'City',
                                                      role: 'Role',
                                                      email: 'Email',
                                                      phone: 'Phone',
                                                      country_code: 'Country Code'
                                                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Salutation/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Street/)
    expect(rendered).to match(/Zip/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Country Code/)
  end
end
