class AddMealSlotsToEventMeals < ActiveRecord::Migration[7.2]
  def change
    add_column :event_meals, :lunch1, :integer
    add_column :event_meals, :dinner1, :integer
    add_column :event_meals, :lunch2, :integer
    add_column :event_meals, :dinner2, :integer
    add_column :event_meals, :lunch3, :integer
    add_column :event_meals, :dinner3, :integer
  end
end
