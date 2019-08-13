class ConcertsController < AuthorityController
  authorize_actions_for Concert, :except => :create 

  authority_actions :future=> 'read', :inactive => 'read', :publish=> 'update'

  before_action :set_concert, only: [:show, :edit, :update, :destroy]
  #, :actions => {:neuter => :update},

  # GET /concerts
  # GET /concerts.json
  layout :choose_layout
  helper_method :sort_column, :sort_direction

  #skip_authorize_resource :only => :show

  def publish 
	  @concert = Concert.find(params[:id])
	  @concert.confirmed = Time.now
	  @concert.visible = true
	  @concert.save

    respond_to do |format|
      if @concert.save
  	    flash[:notice] = t('concert.publish_success')
        format.html { redirect_to inactive_concerts_path, :notice => t('concert.publish_success') }
        format.js {} 
        format.json { render :json=>{ :status=>"ok", :op=> 'delete', :entityId=>@concert.id } }
      else
        format.html { render :action => "new" }
        format.json { render :json => @concert.errors, :status => :unprocessable_entity }
      end
    end

  end

  def public 
    @concerts = Concert.published.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end

  def future
    @concerts = Concert.future.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end

  def inactive 
    @concerts = Concert.inactive.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end
  def index
	if @namespace == "public" then
		self.public
		@method="public"
  	end
    @festival_id = params[:event_id]
    
	if (@festival_id != nil ) 
		@concerts = Concert.includes(:festival).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    else
      @concerts = Concert.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html # index.html.erb
	  format.js
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
    @lvs = RegionalOrganization.all
    @states = State.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @concert }
    end
  end

  # GET /concerts/1/edit
  def edit
    @concert = Concert.find(params[:id])
    authorize_action_for @concert
    @lvs = RegionalOrganization.all
    @states = State.all
  end

  # POST /concerts
  # POST /concerts.json
  def create
    @concert = Concert.new(concert_params)
    @concert.reported = Time.new
    @concert.uid = UUID.new.generate

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

  # PUT /concerts/1
  # PUT /concerts/1.json
  def update
    @concert = Concert.find(params[:id])

    if @concert.uid.nil? then
      @concert.uid= SecureRandom.uuid
    end

    respond_to do |format|
      if @concert.update(concert_params)
        format.html { redirect_to @concert, :notice => 'Concert was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @concert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /concerts/1
  # DELETE /concerts/1.json
  def destroy
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

  def set_concert
    @concert = Concert.find(params[:id])

    authorize_action_for @concert
  end

  def concert_params
    params.require(:concert).permit(:eintritt, :token, :stadt, :titel, :ort, :festival_id, :interpret, :url, :comment, :bundesland, :bland, :email, :owner, :visible, :orchestra_id, :uid, :country_code, :concert_date, :mglnr)
  end
end
