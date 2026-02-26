class AddOutDoorFlagToFestivalPieces < ActiveRecord::Migration[7.2]
  def change
    add_column :festival_pieces, :outdoor, :boolean
  end
end
