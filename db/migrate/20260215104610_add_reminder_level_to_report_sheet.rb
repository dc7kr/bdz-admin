class AddReminderLevelToReportSheet < ActiveRecord::Migration[7.2]
  def change
    add_column :report_sheets, :reminder_level, :integer, default: 0
  end
end
