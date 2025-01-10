module FestivalPiecesHelper
  def festival_pieces_count
    pluralize(FestivalPiece.count, 'comment')
  end
end
