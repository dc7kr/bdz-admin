class EventCardsController < AuthenticatedController
  # GET /event_cards
  # GET /event_cards.json
  def index
    @event_cards = EventCard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_cards }
    end
  end

  # GET /event_cards/1
  # GET /event_cards/1.json
  def show
    @event_card = EventCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_card }
    end
  end

  # GET /event_cards/new
  # GET /event_cards/new.json
  def new
    @event_card = EventCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_card }
    end
  end

  # GET /event_cards/1/edit
  def edit
    @event_card = EventCard.find(params[:id])
  end

  # POST /event_cards
  # POST /event_cards.json
  def create
    @event_card = EventCard.new(params[:event_card])

    respond_to do |format|
      if @event_card.save
        format.html { redirect_to @event_card, notice: 'Event card was successfully created.' }
        format.json { render json: @event_card, status: :created, location: @event_card }
      else
        format.html { render action: "new" }
        format.json { render json: @event_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_cards/1
  # PUT /event_cards/1.json
  def update
    @event_card = EventCard.find(params[:id])

    respond_to do |format|
      if @event_card.update_attributes(params[:event_card])
        format.html { redirect_to @event_card, notice: 'Event card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_cards/1
  # DELETE /event_cards/1.json
  def destroy
    @event_card = EventCard.find(params[:id])
    @event_card.destroy

    respond_to do |format|
      format.html { redirect_to event_cards_url }
      format.json { render :json=>{ :status=>"ok", :op=>"delete", :entityId=>@event_card.id } }
    end
  end
end
