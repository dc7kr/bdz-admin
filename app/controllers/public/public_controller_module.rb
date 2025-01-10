module Public::PublicControllerModule
  # GET /concerts
  # GET /concerts.json

  include ApplicationHelper

  protected

  def noAuthActions
    %w[index show]
  end
end
