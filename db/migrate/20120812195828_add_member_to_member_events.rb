class AddMemberToMemberEvents < ActiveRecord::Migration

 def up
    change_table :member_events do |t|
      t.references :member
    end
  end
 
  def down
    remove_column :member_events, :member
  end
end
