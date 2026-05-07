class FestivalConcertsController < AuthenticatedController
  # GET /festival_concerts
  # GET /festival_concerts.json

  before_action :set_festival_concert, only: %i[ show edit update destroy programme ]

  helper FestivalApplicationsHelper
  helper FestivalPiecesHelper

  def index
    @festival_concerts = policy_scope(FestivalConcert).current_festival.order(:number)

    respond_to do |format|
      format.html # index.html.erb
      format.pdf {
        combined_file = CombinePDF.new
        @festival_concerts.each do |c|
          pdf = FestivalConcertPdf.new(c, view_context)
          pdf.generate
          combined_file << CombinePDF.parse(pdf.render)
        end
        send_data combined_file.to_pdf, filename: "festival_concerts.pdf", type: "application/pdf"
      }

      format.json { render json: @festival_concerts }
    end
  end

  # GET /festival_concerts/1
  # GET /festival_concerts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.pdf  do
        pdf = FestivalConcertPdf.new(@festival_concert, view_context)
        pdf.generate
        filename = "concert_#{@festival_concert.number}.pdf"
        send_data pdf.render, filename: filename, type: "application/pdf"
      end
      format.json { render json: @festival_concert }
    end
  end

  # GET /festival_concerts/new
  # GET /festival_concerts/new.json
  def new
    @festival_concert = FestivalConcert.new
    authorize @festival_concert

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_concert }
    end
  end

  # GET /festival_concerts/1/edit
  def edit
  end

  # POST /festival_concerts
  # POST /festival_concerts.json
  def create
    @festival_concert = FestivalConcert.new(festival_concert_params)
    authorize @festival_concert

    respond_to do |format|
      if @festival_concert.save
        format.html { redirect_to @festival_concert, notice: "Festival concert was successfully created." }
        format.json { render json: @festival_concert, status: :created, location: @festival_concert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @festival_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_concerts/1
  # PUT /festival_concerts/1.json
  def update
    respond_to do |format|
      if @festival_concert.update(festival_concert_params)
        format.html { redirect_to @festival_concert, notice: "Festival concert was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_concerts/1
  # DELETE /festival_concerts/1.json
  def destroy
    @festival_concert.destroy

    respond_to do |format|
      format.html { redirect_to festival_concerts_url }
      format.json { head :no_content }
    end
  end

  def programme
    @groups = policy_scope(FestivalApplication).where(festival_concert_id: params[:id])


    respond_to do |format|
      format.turbo_stream { render template: "festival_concerts/programme" }
      format.html { render template: "festival_concerts/programme" }
    end
  end

  def festival_concert_params
    params.require(:festival_concert).permit(:concert_type, :number, :title, :location, :event_time, :outdoor, :concert_id)
  end

  def details
    @festival_concerts = policy_scope(FestivalConcert).current_festival.includes(:festival_applications, :outdoor_participants)


    array = Array.new

    @festival_concerts.each do |concert|
      array << concert.to_hash
    end

    send_data YAML.dump(array), filename: "concert_details.yml", type: "application/octet-stream"

  end


  def overview

    @applications = policy_scope(FestivalApplication).current_festival.where(permission: true).includes(:festival_concert).includes(:festival_pieces).includes(:contact_person)
    respond_to do |format|
      format.html
      format.ods do
        spreadsheet = FestivalConcertOverviewSpreadsheet.new(@applications)
        spreadsheet.render(self)
        send_data spreadsheet.bytes, filename: "concert_overview.ods", type: "application/octet-stream"
      end
    end
  end


  private
  def set_festival_concert
    @festival_concert = policy_scope(FestivalConcert).find(params[:id])
    authorize @festival_concert
  end
  def index_actions
    super.append(:overview, :details)
  end
end
