class Public::ConcertsController < ApplicationController
  # GET /concerts
  # GET /concerts.json
  helper_method :sort_column, :sort_direction

  # override
  def index
    lv_id = params[:lv_id]

    params[:regional_organization_id] if lv_id.nil?

    if params[:lv_id].nil?
      @concerts = Concert.published.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)
      @ensemble_concerts = EnsembleConcert.all
    else
      @concerts = Concert.published.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)
      @ensemble_concerts = EnsembleConcert.all
    end
    # @ensemble_concerts = EnsembleConcert.published.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
  end

  def magazine
    @concerts = Concert.published.order(%i[datum zeit])
  end

  def renderConcerts
    @concerts = Concert.published.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concerts }
    end
  end

  # GET /concerts/1
  # GET /concerts/1.json
  def show
    @concert = Concert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @concert }
    end
  end

  # GET /concerts/new
  # GET /concerts/new.json
  def new
    @concert = Concert.new
    @concert.country_code = 'DE'
    @lvs = RegionalOrganization.all
    @states = State.all
    @festivals = Festival.where('startdate > ? or id=0', Time.now)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @concert }
    end
  end

  def edit
    @concert = Concert.find_by uid: params[:id]
    @lvs = RegionalOrganization.all
    @states = State.all
    @festivals = Festival.where('startdate > ? or id=0', Time.now)
  end

  # POST /concerts.json
  def create
    @concert = Concert.new(concert_params)
    @concert.reported = Time.now
    @concert.uid = SecureRandom.uuid
    @states = State.all
    @festivals = Festival.where('startdate > ? or id=0', Time.now)

    respond_to do |format|
      if @concert.save
        format.html { redirect_to @concert, notice: 'Concert was successfully created.' }
        format.json { render json: @concert, status: :created, location: @concert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @concert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @concert = Concert.find(params[:id])
    @concert.destroy

    respond_to do |format|
      format.html { redirect_to concerts_url }
      format.json { head :ok }
    end
  end

  private

  def sort_column
    Concert.column_names.include?(params[:sort]) ? params[:sort] : 'datum'
  end

  def concert_params
    params.require(:concert).permit(:eintritt, :token, :stadt, :titel, :ort, :festival_id, :interpret, :url, :comment,
                                    :bundesland, :bland, :email, :owner, :visible, :orchestra_id, :uid, :country_code, :concert_date, :mglnr)
  end
end
