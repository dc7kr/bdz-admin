class AddOutdoorToFestivalConcerts < ActiveRecord::Migration
  def change
    add_column :festival_concerts, :outdoor, :boolean
  end
end
