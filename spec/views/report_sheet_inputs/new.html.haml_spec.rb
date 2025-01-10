require 'rails_helper'

RSpec.describe 'report_sheet_inputs/new', type: :view do
  before(:each) do
    assign(:report_sheet_input, ReportSheetInput.new(
                                  report_sheet_id: 1,
                                  orchestra_id: 1,
                                  token: 'MyString',
                                  admin_flag: false
                                ))
  end

  it 'renders new report_sheet_input form' do
    render

    assert_select 'form[action=?][method=?]', report_sheet_inputs_path, 'post' do
      assert_select 'input#report_sheet_input_report_sheet_id[name=?]', 'report_sheet_input[report_sheet_id]'

      assert_select 'input#report_sheet_input_orchestra_id[name=?]', 'report_sheet_input[orchestra_id]'

      assert_select 'input#report_sheet_input_token[name=?]', 'report_sheet_input[token]'

      assert_select 'input#report_sheet_input_admin_flag[name=?]', 'report_sheet_input[admin_flag]'
    end
  end
end
