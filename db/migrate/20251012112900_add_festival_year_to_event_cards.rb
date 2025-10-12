class AddFestivalYearToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :festival_year, :integer
  end
end
