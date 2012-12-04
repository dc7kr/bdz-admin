class AddInstrToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :zo, :boolean

    add_column :report_sheets, :zi_o, :boolean

    add_column :report_sheets, :go, :boolean

    add_column :report_sheets, :oz, :boolean

  end
end
