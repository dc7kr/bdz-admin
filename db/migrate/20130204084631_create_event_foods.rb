class CreateEventFoods < ActiveRecord::Migration[4.2]
  def change
    create_table :event_food do |t|

      t.timestamps
    end
  end
end
