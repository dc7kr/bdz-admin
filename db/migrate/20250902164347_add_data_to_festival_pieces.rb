class AddDataToFestivalPieces < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_pieces, :arranger, :text
    add_column :festival_pieces, :publisher, :text
  end
end
