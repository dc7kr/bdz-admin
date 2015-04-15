class Public::ConcertsController < ApplicationController 
  # GET /concerts
  # GET /concerts.json
  helper_method :sort_column, :sort_direction

  # override
  def index
	@currentTab = params[:tab];
	if ( @currentTab == nil ) then
		@currentTab = 0 
	end

	if ( @currentTab == 0 ) then 
		renderConcerts
	elsif (@currentTab==1) then
		renderEnsembleConcerts(params)
	elsif (@currentTab==2) then 
		renderFestivals(params)
    end
  end

  def renderEnsembleConcerts
    respond_to do |format|
      format.html { render :partial=>"ensembleConcerts" }
	# index.html.erb
      format.json { render :json => @concerts }
    end
  end

  def renderFestivals
    respond_to do |format|
      format.html { render :partial=>"festivals" }
      format.json { render :json => @concerts }
    end
  end


  def magazine
    @concerts = Concert.public.order([:datum,:zeit])
  end

  def renderConcerts
    @concerts = Concert.public.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end
  # GET /concerts/1
  # GET /concerts/1.json
  def show
    @concert = Concert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @concert }
    end
  end

  # GET /concerts/new
  # GET /concerts/new.json
  def new
    @concert = Concert.new
    @concert.country_code='de'
    @lvs = RegionalOrganization.all
    @states = State.all
    @festivals = Festival.where("startdate > ? or id=0",Time.now)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @concert }
    end
  end

  # POST /concerts.json
  def create
    @concert = Concert.new(params[:concert])
    @concert.reported=Time.now

    respond_to do |format|
      if @concert.save
        format.html { redirect_to @concert, :notice => 'Concert was successfully created.' }
        format.json { render :json => @concert, :status => :created, :location => @concert }
      else
        format.html { render :action => "new" }
        format.json { render :json => @concert.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit 
	redirect_to edit_concert_path(params[:id])
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
    Concert.column_names.include?(params[:sort]) ? params[:sort] : "datum"
  end
end
