class Infodesk::EventCardsController < EventCardsController
  
  def search
    @event_card = EventCard.find(params[:search])
  end

end
