class AddCommentToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :comment, :string
  end
end
