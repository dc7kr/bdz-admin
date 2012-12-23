class AddFilenameToMemberEvents < ActiveRecord::Migration
  def change
    add_column :member_events, :filename, :string

  end
end
