class AddFieldsToFestivalPieces < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_pieces, :soloist, :text
    add_column :festival_pieces, :premiere, :boolean
  end
end
