class AddCommentToMemberEvents < ActiveRecord::Migration
  def change
    add_column :member_events, :comment, :string

  end
end
