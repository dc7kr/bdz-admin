class AddCommentToReportSheet < ActiveRecord::Migration[4.2]
  def change
    add_column :report_sheets, :comment, :string
  end
end
