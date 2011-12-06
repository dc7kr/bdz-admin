class EnsemblesController < ApplicationController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  # GET /ensembles
  # GET /ensembles.json
  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  load_and_authorize_resource
  def index
    @ensembles = Ensemble.search(params[:search]).order(sort_column+ " "+ sort_direction).paginate(:per_page => 20, :page => params[:page])


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


  private 
  def sort_column
    Ensemble.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
