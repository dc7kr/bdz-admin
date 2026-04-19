class AddAddonsToFestivalExhibitor < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_exhibitors, :advert_type, :integer
    add_column :festival_exhibitors, :rollups, :integer
  end
end
