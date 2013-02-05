class CreateEventFoods < ActiveRecord::Migration
  def change
    create_table :event_foods do |t|

      t.timestamps
    end
  end
end
