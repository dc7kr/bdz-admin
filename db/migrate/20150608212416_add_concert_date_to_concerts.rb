class AddConcertDateToConcerts < ActiveRecord::Migration
  def change
    add_column :concerts, :concert_date, :datetime
  end
end
