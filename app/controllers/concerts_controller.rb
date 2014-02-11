class ConcertsController < AuthenticatedController
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
        format.json { render :json=>{ :status=>"ok", :entityId=>@concert.id } }
      else
        format.html { render :action => "new" }
        format.json { render :json => @concert.errors, :status => :unprocessable_entity }
      end
    end

  end

  def public 
    @concerts = Concert.public.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
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
	#@Concerts = Concert.where(:all,:include=>[:country,:state,:festival],:conditions=>"datum >= date(now()),festival_id = @festival_id").paginate(:per_page => 20, :page => params[:page])
		@concerts = Concert.includes(:festival).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
    else
      #@concerts = Concert.where(:all,:include=>[:country,:state,:festival],:conditions=>"datum >= date(now())").paginate(:per_page => 20, :page => params[:page])
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
    @lvs = RegionalOrganization.all
    @states = State.all
  end

  # POST /concerts
  # POST /concerts.json
  def create
    @concert = Concert.new(params[:concert])

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

    respond_to do |format|
      if @concert.update_attributes(params[:concert])
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
    @concert = Concert.find(params[:id])
    @concert.destroy

    respond_to do |format|
      format.html { redirect_to concerts_url }
      format.json { head :ok }
    end
  end

  # OVERRIDE 
  protected
  def noAuthActions 
		["index","show","public"]
  end


  private 
  def sort_column
    Concert.column_names.include?(params[:sort]) ? params[:sort] : "datum"
  end

end
