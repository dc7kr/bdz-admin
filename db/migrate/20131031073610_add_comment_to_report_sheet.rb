class AddCommentToReportSheet < ActiveRecord::Migration
  def change
    add_column :report_sheets, :comment, :string
  end
end
