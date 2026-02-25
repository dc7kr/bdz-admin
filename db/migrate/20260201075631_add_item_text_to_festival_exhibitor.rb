class AddItemTextToFestivalExhibitor < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_exhibitors, :item_text, :string
  end
end
