class EnsembleConcertsController < AuthenticatedController
  # for table sort by column click

  include CountryHelper

  helper_method :sort_column, :sort_direction

  # GET /ensembles
  # GET /ensembles.json
  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  load_and_authorize_resource

  def publish
	@ensemble_concert = EnsembleConcert.find(params[:id])
	@ensemble = Ensemble.find(@ensemble_concert.ensemble_id)
	@ensemble_concert.confirmed = Time.now
	@ensemble_concert.visible = true
	@ensemble_concert.save

    respond_to do |format|
      if @ensemble_concert.save
        format.html { redirect_to ensemble_ensemble_concert_path(@ensemble,@ensemble_concert), :notice => t('ensemble_concert.publish_success') }
        format.json { render :json => @ensemble_concert, :status => :created, :location => @ensemble_concert }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ensemble_concert.errors, :status => :unprocessable_entity }
      end
    end
  end


  def public 
    @ensemble_concerts = EnsembleConcert.public.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end


  def inactive

	@ensemble=nil
    if params[:ensemble_id] != nil then
		@ensemble = Ensemble.find(params[:ensemble_id])
    end

    if ( @ensemble == nil ) then
		@ensemble_concerts = EnsembleConcert.inactive.page(params[:page]).per(20)
	else
		@ensemble_concerts = EnsembleConcert.inactive.where("ensemble_id = ?",params[:ensemble_id]).page(params[:page]).per(20)
	end

    respond_to do |format|
      format.html # index.html.erb
	  format.js
      format.json { render :json => @ensemble_concerts }
    end
  end

  def index
	@ensemble = nil
	@ensemble_concerts = nil

	if @namespace == "public" then
		self.public
		@method="public"
  	end
 	if ( params[:ensemble_id] ) then
		@ensemble = Ensemble.find(params[:ensemble_id])
		@ensemble_concerts = EnsembleConcert.where("ensemble_id = ?",params[:ensemble_id]).page(params[:page]).per(20)
	else
		@ensemble_concerts = EnsembleConcert.page(params[:page]).per(20)
	end

    respond_to do |format|
      format.html # index.html.erb
	  format.js
      format.json { render :json => @ensemble_concerts }
    end
  end

  def show
	@ensemble = Ensemble.find(params[:ensemble_id])
	@ensemble_concert = EnsembleConcert.find(params[:id])
  end

  # GET /ensemble_concerts/new
  # GET /ensemble_concerts/new.json
  def new
    @ensemble_concert = EnsembleConcert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ensemble_concert }
    end
  end

  # GET /ensemble_concerts/1/edit
  def edit
	  @ensemble = Ensemble.find(params[:ensemble_id])
    @ensemble_concert = EnsembleConcert.find(params[:id])
  	@festivals = Festival.all
	  @states = State.all
  end


  # POST /ensemble_concerts
  # POST /ensemble_concerts.json
  def create
    @ensemble_concert = EnsembleConcert.new(params[:ensemble_concert])
    respond_to do |format|
      if @ensemble_concert.save
        format.html { redirect_to ensemble_ensemble_concerts_path(@ensemble,@ensemble_concert), :notice => t('ensemble_concert.create_success') }
        format.json { render :json => @ensemble_concert, :status => :created, :location => @ensemble_concert }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ensemble_concert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ensemble_concerts/1
  # PUT /ensemble_concerts/1.json
  def update
	@ensemble = Ensemble.find(params[:ensemble_id])
    @ensemble_concert = EnsembleConcert.find(params[:id])

    respond_to do |format|
      if @ensemble_concert.update_attributes(params[:ensemble_concert])
        format.html { redirect_to ensemble_ensemble_concert_path(@ensemble,@ensemble_concert), :notice => t('ensemble_concert.update_success') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ensemble_concert.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /ensembles/1
  # DELETE /ensembles/1.json
  def destroy
    @ensemble_concert = EnsembleConcert.find(params[:id])
    @ensemble_concert.destroy

    respond_to do |format|
      format.html { redirect_to ensemble_ensemble_concerts_path(params[:ensemble_id]) }
      format.json { head :ok }
    end
  end

  protected
  def noAuthActions
    ["index","public"]
  end

  private
  def sort_column
    EnsembleConcert.column_names.include?(params[:sort]) ? params[:sort] : "datum"
  end


end
