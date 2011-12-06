class OrchestrasController < ApplicationController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  # GET /orchestras
  # GET /orchestras.json
  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  load_and_authorize_resource
  def index
    @orchestras = Orchestra.search(params[:search]).order(sort_column+ " "+ sort_direction).paginate(:per_page=>10, :page=>params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @orchestras }
    end
  end

  # GET /orchestras/1
  # GET /orchestras/1.json
  def show
    @orchestra = Orchestra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # GET /orchestras/new
  # GET /orchestras/new.json
  def new
    @orchestra = Orchestra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # GET /orchestras/1/edit
  def edit
    @orchestra = Orchestra.find(params[:id])
  end

  # POST /orchestras
  # POST /orchestras.json
  def create
    @orchestra = Orchestra.new(params[:orchestra])

    respond_to do |format|
      if @orchestra.save
        format.html { redirect_to @orchestra, :notice => 'Orchestra was successfully created.' }
        format.json { render :json => @orchestra, :status => :created, :location => @orchestra }
      else
        format.html { render :action => "new" }
        format.json { render :json => @orchestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orchestras/1
  # PUT /orchestras/1.json
  def update
    @orchestra = Orchestra.find(params[:id])

    respond_to do |format|
      if @orchestra.update_attributes(params[:orchestra])
        format.html { redirect_to @orchestra, :notice => 'Orchestra was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @orchestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orchestras/1
  # DELETE /orchestras/1.json
  def destroy
    @orchestra = Orchestra.find(params[:id])
    @orchestra.destroy

    respond_to do |format|
      format.html { redirect_to orchestras_url }
      format.json { head :ok }
    end
  end
  private 
  def sort_column
    Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "mglnr"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
