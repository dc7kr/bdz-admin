class AddConcertTypeToFestivalConcerts < ActiveRecord::Migration
  def change
    add_column :festival_concerts, :concert_type, :string
  end
end
