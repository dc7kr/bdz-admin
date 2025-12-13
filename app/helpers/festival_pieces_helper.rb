module FestivalPiecesHelper
  def festival_pieces_count
    pluralize(FestivalPiece.count, "comment")
  end

  def render_duration(duration_time)
    duration_time.nil? ? "" : duration_time.strftime("%H:%M")
  end
end
