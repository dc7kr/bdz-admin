class AddTitleToFestivalConcert < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_concerts, :title, :string
  end
end
