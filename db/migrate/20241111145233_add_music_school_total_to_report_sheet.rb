class AddMusicSchoolTotalToReportSheet < ActiveRecord::Migration[7.1]
  def change
    add_column :report_sheets, :ms_total, :integer
  end
end
