class AddConcertDateToConcerts < ActiveRecord::Migration[4.2]
  def change
    add_column :concerts, :concert_date, :datetime
  end
end
