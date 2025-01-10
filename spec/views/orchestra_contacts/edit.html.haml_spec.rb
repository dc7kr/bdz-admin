require 'rails_helper'

RSpec.describe 'orchestra_contacts/edit', type: :view do
  before(:each) do
    @orchestra_contact = assign(:orchestra_contact, OrchestraContact.create!(
                                                      orchestra_id: 1,
                                                      salutation: 'MyString',
                                                      first_name: 'MyString',
                                                      last_name: 'MyString',
                                                      street: 'MyString',
                                                      zip: 'MyString',
                                                      city: 'MyString',
                                                      role: 'MyString',
                                                      email: 'MyString',
                                                      phone: 'MyString',
                                                      country_code: 'MyString'
                                                    ))
  end

  it 'renders the edit orchestra_contact form' do
    render

    assert_select 'form[action=?][method=?]', orchestra_contact_path(@orchestra_contact), 'post' do
      assert_select 'input#orchestra_contact_orchestra_id[name=?]', 'orchestra_contact[orchestra_id]'

      assert_select 'input#orchestra_contact_salutation[name=?]', 'orchestra_contact[salutation]'

      assert_select 'input#orchestra_contact_first_name[name=?]', 'orchestra_contact[first_name]'

      assert_select 'input#orchestra_contact_last_name[name=?]', 'orchestra_contact[last_name]'

      assert_select 'input#orchestra_contact_street[name=?]', 'orchestra_contact[street]'

      assert_select 'input#orchestra_contact_zip[name=?]', 'orchestra_contact[zip]'

      assert_select 'input#orchestra_contact_city[name=?]', 'orchestra_contact[city]'

      assert_select 'input#orchestra_contact_role[name=?]', 'orchestra_contact[role]'

      assert_select 'input#orchestra_contact_email[name=?]', 'orchestra_contact[email]'

      assert_select 'input#orchestra_contact_phone[name=?]', 'orchestra_contact[phone]'

      assert_select 'input#orchestra_contact_country_code[name=?]', 'orchestra_contact[country_code]'
    end
  end
end
