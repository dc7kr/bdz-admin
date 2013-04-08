class ChangeFestivalPiecesDurationToString < ActiveRecord::Migration
  def up
		change_column(:festival_pieces, :duration, :string)
  end

  def down
		change_column(:festival_pieces, :duration, :time)
  end
end
