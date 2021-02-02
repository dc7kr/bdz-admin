class AddFilenameToMemberEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :member_events, :filename, :string

  end
end
