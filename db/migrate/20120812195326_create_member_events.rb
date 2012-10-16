class CreateMemberEvents < ActiveRecord::Migration
  def change
    create_table :member_events do |t|
      t.string :event_type
      t.datetime :event_date
      t.string :event_id

      t.timestamps
    end
  end
end
