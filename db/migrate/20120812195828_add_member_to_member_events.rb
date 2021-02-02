class AddMemberToMemberEvents < ActiveRecord::Migration[4.2]

 def up
    change_table :member_events do |t|
      t.references :member
    end
  end
 
  def down
    remove_column :member_events, :member
  end
end
