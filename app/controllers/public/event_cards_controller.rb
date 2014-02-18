class Public::EventCardsController < Public::ApplicationController

  def order_form
    @event_card = EventCard.new

    @prices = BDZ_SETTINGS["festival_prices"]
  end

  def order_success
    @event_card = EventCard.new(params[:event_card])

    @event_card.orderdate = Time.now
    respond_to do |format|
      if @event_card.save

        EventCardsMailer.notify(@event_card,"kartenbestellung@bdz-online.de").deliver
        format.html 
        format.json { render json: @event_card, status: :created, location: @event_card }
      else
        format.html { render action: "new" }
        format.json { render json: @event_card.errors, status: :unprocessable_entity }
      end
    end
  end
end


