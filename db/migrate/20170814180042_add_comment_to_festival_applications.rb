class AddCommentToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :comment, :string
  end
end
