class GemaEventsController < ApplicationController
  before_action :set_gema_event, only: %i[show edit update destroy]

  # GET /gema_events or /gema_events.json
  def index
    @gema_events = GemaEvent.all
  end

  # GET /gema_events/1 or /gema_events/1.json
  def show; end

  # GET /gema_events/new
  def new
    @gema_event = GemaEvent.new
  end

  # GET /gema_events/1/edit
  def edit; end

  # POST /gema_events or /gema_events.json
  def create
    @gema_event = GemaEvent.new(gema_event_params)

    respond_to do |format|
      if @gema_event.save
        format.html { redirect_to @gema_event, notice: 'Gema event was successfully created.' }
        format.json { render :show, status: :created, location: @gema_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gema_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gema_events/1 or /gema_events/1.json
  def update
    respond_to do |format|
      if @gema_event.update(gema_event_params)
        format.html { redirect_to @gema_event, notice: 'Gema event was successfully updated.' }
        format.json { render :show, status: :ok, location: @gema_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gema_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gema_events/1 or /gema_events/1.json
  def destroy
    @gema_event.destroy!

    respond_to do |format|
      format.html { redirect_to gema_events_path, status: :see_other, notice: 'Gema event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gema_event
    @gema_event = GemaEvent.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gema_event_params
    params.require(:gema_event).permit(:sap_nr, :kdnr, :orchestra_id, :name, :license_nr, :event_date, :description, :location, :tariff, :ticket_total, :admission_price, :music_effort, :visitors, :room_size, :setlist, :gema_amount, :gstv_reduction, :cultural_reduction, :e_reduction, :netto)
  end
end
