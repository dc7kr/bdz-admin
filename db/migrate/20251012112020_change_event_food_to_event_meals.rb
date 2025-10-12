class ChangeEventFoodToEventMeals < ActiveRecord::Migration[7.2]
  def up
    rename_table :event_food, :event_meals
  end
  def down
    rename_table :event_meals, :event_food
  end
end
