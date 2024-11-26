class ChangeInstrumentationToNumber < ActiveRecord::Migration[7.1]
  def change
    change_column(:report_sheets, :zo, :integer)
    change_column(:report_sheets, :go, :integer)
    change_column(:report_sheets, :zi_o, :integer)
    change_column(:report_sheets, :oz, :integer)
  end
end
