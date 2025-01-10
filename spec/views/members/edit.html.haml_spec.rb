require 'rails_helper'

RSpec.describe 'members/edit', type: :view do
  before(:each) do
    @member = assign(:member, Member.create!(
                                subtype: 'MyString',
                                regional_organization_id: 1,
                                mglnr: 1,
                                anrede: 'MyString',
                                vorname: 'MyString',
                                name: 'MyString',
                                strasse: 'MyString',
                                plz: 'MyString',
                                ort: 'MyString',
                                email: 'MyString',
                                za: 'MyString',
                                konto: 1,
                                blz: 'MyString',
                                zahler: 'MyString',
                                telefon: 'MyString',
                                fax: 'MyString',
                                bic: 'MyString',
                                iban: 'MyString',
                                country_code: 'MyString'
                              ))
  end

  it 'renders the edit member form' do
    render

    assert_select 'form[action=?][method=?]', member_path(@member), 'post' do
      assert_select 'input#member_subtype[name=?]', 'member[subtype]'

      assert_select 'input#member_regional_organization_id[name=?]', 'member[regional_organization_id]'

      assert_select 'input#member_mglnr[name=?]', 'member[mglnr]'

      assert_select 'input#member_anrede[name=?]', 'member[anrede]'

      assert_select 'input#member_vorname[name=?]', 'member[vorname]'

      assert_select 'input#member_name[name=?]', 'member[name]'

      assert_select 'input#member_strasse[name=?]', 'member[strasse]'

      assert_select 'input#member_plz[name=?]', 'member[plz]'

      assert_select 'input#member_ort[name=?]', 'member[ort]'

      assert_select 'input#member_email[name=?]', 'member[email]'

      assert_select 'input#member_za[name=?]', 'member[za]'

      assert_select 'input#member_konto[name=?]', 'member[konto]'

      assert_select 'input#member_blz[name=?]', 'member[blz]'

      assert_select 'input#member_zahler[name=?]', 'member[zahler]'

      assert_select 'input#member_telefon[name=?]', 'member[telefon]'

      assert_select 'input#member_fax[name=?]', 'member[fax]'

      assert_select 'input#member_bic[name=?]', 'member[bic]'

      assert_select 'input#member_iban[name=?]', 'member[iban]'

      assert_select 'input#member_country_code[name=?]', 'member[country_code]'
    end
  end
end
