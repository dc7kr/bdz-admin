class AddSubtitleToFestivalConcerts < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_concerts, :subtitle, :string
  end
end
