class CreateEventFoods < ActiveRecord::Migration
  def change
    create_table :event_food do |t|

      t.timestamps
    end
  end
end
