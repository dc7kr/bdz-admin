class AddInvoicedToReportSheets < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :invoiced, :boolean
  end
end
