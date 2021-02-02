class AddSupportersToReportSheet < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :supporters, :integer

  end
end
