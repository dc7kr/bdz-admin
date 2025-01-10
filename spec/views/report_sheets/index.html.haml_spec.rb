require 'rails_helper'

RSpec.describe 'report_sheets/index', type: :view do
  before(:each) do
    assign(:report_sheets, [
             ReportSheet.create!(
               year: 1,
               orchestra_id: 2,
               children: 3,
               teens: 4,
               youth: 5,
               adult: 6,
               uv: 7,
               zeitungen: 8,
               gema: 9,
               azubi: 10,
               passive: 11,
               child_ens: 12,
               youth_ens: 13,
               adult_ens: 14,
               senior_ens: 15,
               chamber_ens: 16,
               other_ens: 17,
               token: 'Token',
               azubi_child: 18,
               azubi_teens: 19,
               azubi_youth: 20,
               azubi_adult: 21,
               azubi_senior: 22,
               supporters: 23,
               zo: false,
               zi_o: false,
               go: false,
               oz: false,
               invoiced: false,
               comment: 'Comment',
               generated: false
             ),
             ReportSheet.create!(
               year: 1,
               orchestra_id: 2,
               children: 3,
               teens: 4,
               youth: 5,
               adult: 6,
               uv: 7,
               zeitungen: 8,
               gema: 9,
               azubi: 10,
               passive: 11,
               child_ens: 12,
               youth_ens: 13,
               adult_ens: 14,
               senior_ens: 15,
               chamber_ens: 16,
               other_ens: 17,
               token: 'Token',
               azubi_child: 18,
               azubi_teens: 19,
               azubi_youth: 20,
               azubi_adult: 21,
               azubi_senior: 22,
               supporters: 23,
               zo: false,
               zi_o: false,
               go: false,
               oz: false,
               invoiced: false,
               comment: 'Comment',
               generated: false
             )
           ])
  end

  it 'renders a list of report_sheets' do
    render
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 3.to_s, count: 2
    assert_select 'tr>td', text: 4.to_s, count: 2
    assert_select 'tr>td', text: 5.to_s, count: 2
    assert_select 'tr>td', text: 6.to_s, count: 2
    assert_select 'tr>td', text: 7.to_s, count: 2
    assert_select 'tr>td', text: 8.to_s, count: 2
    assert_select 'tr>td', text: 9.to_s, count: 2
    assert_select 'tr>td', text: 10.to_s, count: 2
    assert_select 'tr>td', text: 11.to_s, count: 2
    assert_select 'tr>td', text: 12.to_s, count: 2
    assert_select 'tr>td', text: 13.to_s, count: 2
    assert_select 'tr>td', text: 14.to_s, count: 2
    assert_select 'tr>td', text: 15.to_s, count: 2
    assert_select 'tr>td', text: 16.to_s, count: 2
    assert_select 'tr>td', text: 17.to_s, count: 2
    assert_select 'tr>td', text: 'Token'.to_s, count: 2
    assert_select 'tr>td', text: 18.to_s, count: 2
    assert_select 'tr>td', text: 19.to_s, count: 2
    assert_select 'tr>td', text: 20.to_s, count: 2
    assert_select 'tr>td', text: 21.to_s, count: 2
    assert_select 'tr>td', text: 22.to_s, count: 2
    assert_select 'tr>td', text: 23.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'Comment'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
