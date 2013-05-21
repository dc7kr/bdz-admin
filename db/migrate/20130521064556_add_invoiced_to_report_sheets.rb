class AddInvoicedToReportSheets < ActiveRecord::Migration
  def change
    add_column :report_sheets, :invoiced, :boolean
  end
end
