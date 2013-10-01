class AddTitleToFestivalConcert < ActiveRecord::Migration
  def change
    add_column :festival_concerts, :title, :string
  end
end
