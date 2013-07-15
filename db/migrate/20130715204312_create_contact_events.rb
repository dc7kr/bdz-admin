class CreateContactEvents < ActiveRecord::Migration
  def change
    create_table :contact_events do |t|
      t.string :event_type
      t.datetime :event_date
      t.string :event_id
      t.integer :contact_id
      t.string :comment
      t.string :filename

      t.timestamps
    end
  end
end
