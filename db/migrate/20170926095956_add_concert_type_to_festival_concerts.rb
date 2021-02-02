class AddConcertTypeToFestivalConcerts < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_concerts, :concert_type, :string
  end
end
