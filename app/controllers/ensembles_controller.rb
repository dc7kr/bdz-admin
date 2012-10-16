class EnsemblesController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction
  layout :choose_layout

  # GET /ensembles
  # GET /ensembles.json
  
  #load_and_authorize_resource
  def public
	@ensembles = Ensemble.includes(:public_concerts)
    respond_to do |format|
      format.html 
	# index.html.erb
      format.json { render :json => @concerts }
    end
  end

  def inactive 
    @ensembles = Ensemble.inactive().search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(10)
  end
  def index
    @ensembles = Ensemble.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ensembles }
    end
  end

  # GET /ensembles/1
  # GET /ensembles/1.json
  def show
    @ensemble = Ensemble.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ensemble }
    end
  end

  # GET /ensembles/new
  # GET /ensembles/new.json
  def new
    @ensemble = Ensemble.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ensemble }
    end
  end

  # GET /ensembles/1/edit
  def edit
    @ensemble = Ensemble.find(params[:id])
  end

  # POST /ensembles
  # POST /ensembles.json
  def create
    @ensemble = Ensemble.new(params[:ensemble])

    respond_to do |format|
      if @ensemble.save
        format.html { redirect_to @ensemble, :notice => 'Ensemble was successfully created.' }
        format.json { render :json => @ensemble, :status => :created, :location => @ensemble }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ensemble.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ensembles/1
  # PUT /ensembles/1.json
  def update
    @ensemble = Ensemble.find(params[:id])

    respond_to do |format|
      if @ensemble.update_attributes(params[:ensemble])
        format.html { redirect_to @ensemble, :notice => 'Ensemble was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ensemble.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ensembles/1
  # DELETE /ensembles/1.json
  def destroy
    @ensemble = Ensemble.find(params[:id])
    @ensemble.destroy

    respond_to do |format|
      format.html { redirect_to ensembles_url }
      format.json { head :ok }
    end
  end

  protected
  def noAuthActions
	["index","public"]
  end

  private 
  def sort_column
    Ensemble.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
end
