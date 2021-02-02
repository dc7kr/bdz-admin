class AddInstrToReportSheet < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :zo, :boolean

    add_column :report_sheets, :zi_o, :boolean

    add_column :report_sheets, :go, :boolean

    add_column :report_sheets, :oz, :boolean

  end
end
