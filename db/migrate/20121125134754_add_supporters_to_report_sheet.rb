class AddSupportersToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :supporters, :integer

  end
end
