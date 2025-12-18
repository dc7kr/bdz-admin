module FestivalPiecesHelper
  def festival_pieces_count
    pluralize(FestivalPiece.count, "comment")
  end

  def render_duration(duration_time)
    begin
      duration_time.nil? ? "" : duration_time.strftime("%H:%M")
    rescue => e
      "INVALID"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
