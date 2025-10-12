class AddFestivalYearToEventMeals < ActiveRecord::Migration[7.2]
  def change
    add_column :event_meals, :festival_year, :integer
  end
end
