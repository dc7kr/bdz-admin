require 'rails_helper'

RSpec.describe 'report_sheets/new', type: :view do
  before(:each) do
    assign(:report_sheet, ReportSheet.new(
                            year: 1,
                            orchestra_id: 1,
                            children: 1,
                            teens: 1,
                            youth: 1,
                            adult: 1,
                            uv: 1,
                            zeitungen: 1,
                            gema: 1,
                            azubi: 1,
                            passive: 1,
                            child_ens: 1,
                            youth_ens: 1,
                            adult_ens: 1,
                            senior_ens: 1,
                            chamber_ens: 1,
                            other_ens: 1,
                            token: 'MyString',
                            azubi_child: 1,
                            azubi_teens: 1,
                            azubi_youth: 1,
                            azubi_adult: 1,
                            azubi_senior: 1,
                            supporters: 1,
                            zo: false,
                            zi_o: false,
                            go: false,
                            oz: false,
                            invoiced: false,
                            comment: 'MyString',
                            generated: false
                          ))
  end

  it 'renders new report_sheet form' do
    render

    assert_select 'form[action=?][method=?]', report_sheets_path, 'post' do
      assert_select 'input#report_sheet_year[name=?]', 'report_sheet[year]'

      assert_select 'input#report_sheet_orchestra_id[name=?]', 'report_sheet[orchestra_id]'

      assert_select 'input#report_sheet_children[name=?]', 'report_sheet[children]'

      assert_select 'input#report_sheet_teens[name=?]', 'report_sheet[teens]'

      assert_select 'input#report_sheet_youth[name=?]', 'report_sheet[youth]'

      assert_select 'input#report_sheet_adult[name=?]', 'report_sheet[adult]'

      assert_select 'input#report_sheet_uv[name=?]', 'report_sheet[uv]'

      assert_select 'input#report_sheet_zeitungen[name=?]', 'report_sheet[zeitungen]'

      assert_select 'input#report_sheet_gema[name=?]', 'report_sheet[gema]'

      assert_select 'input#report_sheet_azubi[name=?]', 'report_sheet[azubi]'

      assert_select 'input#report_sheet_passive[name=?]', 'report_sheet[passive]'

      assert_select 'input#report_sheet_child_ens[name=?]', 'report_sheet[child_ens]'

      assert_select 'input#report_sheet_youth_ens[name=?]', 'report_sheet[youth_ens]'

      assert_select 'input#report_sheet_adult_ens[name=?]', 'report_sheet[adult_ens]'

      assert_select 'input#report_sheet_senior_ens[name=?]', 'report_sheet[senior_ens]'

      assert_select 'input#report_sheet_chamber_ens[name=?]', 'report_sheet[chamber_ens]'

      assert_select 'input#report_sheet_other_ens[name=?]', 'report_sheet[other_ens]'

      assert_select 'input#report_sheet_token[name=?]', 'report_sheet[token]'

      assert_select 'input#report_sheet_azubi_child[name=?]', 'report_sheet[azubi_child]'

      assert_select 'input#report_sheet_azubi_teens[name=?]', 'report_sheet[azubi_teens]'

      assert_select 'input#report_sheet_azubi_youth[name=?]', 'report_sheet[azubi_youth]'

      assert_select 'input#report_sheet_azubi_adult[name=?]', 'report_sheet[azubi_adult]'

      assert_select 'input#report_sheet_azubi_senior[name=?]', 'report_sheet[azubi_senior]'

      assert_select 'input#report_sheet_supporters[name=?]', 'report_sheet[supporters]'

      assert_select 'input#report_sheet_zo[name=?]', 'report_sheet[zo]'

      assert_select 'input#report_sheet_zi_o[name=?]', 'report_sheet[zi_o]'

      assert_select 'input#report_sheet_go[name=?]', 'report_sheet[go]'

      assert_select 'input#report_sheet_oz[name=?]', 'report_sheet[oz]'

      assert_select 'input#report_sheet_invoiced[name=?]', 'report_sheet[invoiced]'

      assert_select 'input#report_sheet_comment[name=?]', 'report_sheet[comment]'

      assert_select 'input#report_sheet_generated[name=?]', 'report_sheet[generated]'
    end
  end
end
