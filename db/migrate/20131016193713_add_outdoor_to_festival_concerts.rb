class AddOutdoorToFestivalConcerts < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_concerts, :outdoor, :boolean
  end
end
