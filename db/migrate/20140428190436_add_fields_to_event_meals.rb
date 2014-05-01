class AddFieldsToEventMeals < ActiveRecord::Migration
  def change
    add_column :event_food, :participant_id, :integer
    add_column :event_food, :arrival_time, :datetime
  end
end
