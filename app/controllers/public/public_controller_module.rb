module Public::PublicControllerModule 
  # GET /concerts
  # GET /concerts.json


  protected
  def noAuthActions
	["index","show"]
  end
end
