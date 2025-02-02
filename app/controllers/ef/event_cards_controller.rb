module Ef
  class EventCardsController < Public::ApplicationController
    include ::ApplicationHelper

    def order_form
      @event_card = EventCard.new
      @prices = BDZ_SETTINGS['festival_prices']
    end

    def order_success
      @event_card = EventCard.new(event_card_params)
      @prices = BDZ_SETTINGS['festival_prices']

      @event_card.orderdate = Time.zone.now
      respond_to do |format|
        if @event_card.save

          EventCardsMailer.notify(@event_card, 'kartenbestellung@bdz-online.de').deliver
          format.html
          format.json { render json: @event_card, status: :created, location: @event_card }
        else
          format.html { render action: 'order_form' }
          format.json { render json: @event_card.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def event_card_params
      params.require(:event_card).permit(:email, :name, :email, :street, :zip, :city, :country_code, :preferred_lang,
                                         :nr_fest, :nr_fest_erm, :nr_fest_bdz, :nr_fest_bdz_erm, :nr_do, :nr_do_erm, :nr_fr, :nr_fr_erm, :nr_sa, :nr_sa_erm, :nr_concert_so, :nr_concert_so_erm)
    end
  end
end
