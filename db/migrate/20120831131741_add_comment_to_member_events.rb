class AddCommentToMemberEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :member_events, :comment, :string

  end
end
