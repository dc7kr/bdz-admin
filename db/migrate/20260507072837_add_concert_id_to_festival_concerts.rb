class AddConcertIdToFestivalConcerts < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_concerts, :concert_id, :string
  end
end
