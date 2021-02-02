class AddFieldsToEventMeals < ActiveRecord::Migration[4.2]
  def change
    add_column :event_food, :participant_id, :integer
    add_column :event_food, :arrival_time, :datetime
  end
end
