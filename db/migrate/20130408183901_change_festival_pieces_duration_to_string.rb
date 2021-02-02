class ChangeFestivalPiecesDurationToString < ActiveRecord::Migration[4.2]
  def up
		change_column(:festival_pieces, :duration, :string)
  end

  def down
		change_column(:festival_pieces, :duration, :time)
  end
end
