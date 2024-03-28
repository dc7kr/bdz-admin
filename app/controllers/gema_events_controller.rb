require "roo"
class GemaEventsController < ApplicationController
  before_action :set_gema_event, only: [:show, :edit, :update, :destroy]

  # GET /gema_events
  # GET /gema_events.json
  def index
    @gema_events = GemaEvent.page(params[:page]).per(20)
  end

  # GET /gema_events/1
  # GET /gema_events/1.json
  def show
  end

  # GET /gema_events/new
  def new
    @gema_event = GemaEvent.new
  end

  # GET /gema_events/1/edit
  def edit
  end

  # POST /gema_events
  # POST /gema_events.json
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

  # PATCH/PUT /gema_events/1
  # PATCH/PUT /gema_events/1.json
  def update
    respond_to do |format|
      if @gema_event.update(gema_event_params)
        format.html { redirect_to @gema_event, notice: 'Gema event was successfully updated.' }
        format.json { render :show, status: :ok, location: @gema_event }
      else
        format.html { render :edit }
        format.json { render json: @gema_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gema_events/1
  # DELETE /gema_events/1.json
  def destroy
    @gema_event.destroy
    respond_to do |format|
      format.html { redirect_to gema_events_url, notice: 'Gema event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST
  def import
    Rails.logger.debug(params)
    params[:xls_file]
    uploaded_io = params[:xls_file]

    target_filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

    File.open(target_filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    xlsx = Roo::Spreadsheet.open(target_filename.to_s)

    sh = xlsx.sheet(xlsx.sheets.first)
    p sh.row(1)
    p sh.row(2)

    p sh.row(3)
    p sh.last_row
    rownr=3
    while rownr < sh.last_row do
        row = sh.row(rownr)
        name = row[1]
        mglnr = row[12]
        mglnr = mglnr.gsub(/^.* - /,"")
        mglnr = mglnr.gsub("Bund Deutscher Zupfmusiker","")
        Rails.logger.debug("<"+mglnr.to_s+"> - <"+name.to_s+">\n")
        rownr+=1
    end

    @gema_events = GemaEvent.page(params[:page]).per(20)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gema_event
      @gema_event = GemaEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gema_event_params
      params.require(:gema_event).permit(:kdnr, :name, :zip, :city, :date, :title, :tariff, :amount, :location, :location_city, :program_available, :source, :par_mgl, :nf_id)
    end
end
