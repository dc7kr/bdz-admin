class ClassifiedsController < AuthenticatedController
  helper_method :sort_column, :sort_direction

  def publish 
	@classified = Classified.find(params[:id])
	@classified.confirmed = Time.now
	@classified.visible = true
	@classified.save
  flash[:notice]= t('classified.publish_success')

    respond_to do |format|
      if @classified.save
        format.html { redirect_to inactive_classifieds_path, :notice => t('classified.publish_success') }
        format.json { render :json=>{ :status=>"ok", :entityId=>@classified.id } }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @classified.errors, :status => :unprocessable_entity }
      end
    end

  end

  def inactive 
    @classifieds = Classified.inactive.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @concerts }
    end
  end

  # GET /classifieds
  # GET /classifieds.json
  def index
    @classifieds= Classified.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)


    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @classifieds }
    end
  end

  # GET /classifieds/1
  # GET /classifieds/1.json
  def show
    @classified = Classified.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @classified }
    end
  end

  # GET /classifieds/new
  # GET /classifieds/new.json
  def new
    @classified = Classified.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @classified }
    end
  end

  # GET /classifieds/1/edit
  def edit
    @classified = Classified.find(params[:id])
  end

  # POST /classifieds
  # POST /classifieds.json
  def create
    @classified = Classified.new(params[:classified])

    respond_to do |format|
      if @classified.save
        format.html { redirect_to @classified, notice: 'Classified was successfully created.' }
        format.json { render json: @classified, status: :created, location: @classified }
      else
        format.html { render action: "new" }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classifieds/1
  # PUT /classifieds/1.json
  def update
    @classified = Classified.find(params[:id])

    respond_to do |format|
      if @classified.update_attributes(params[:classified])
        format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classifieds/1
  # DELETE /classifieds/1.json
  def destroy
    @classified = Classified.find(params[:id])
    @classified.destroy
    flash[:notice]= t('classified.delete_success')

    respond_to do |format|
      format.html { redirect_to classifieds_url }
      format.json { head :no_content }
      format.json { render :json=>{ :status=>"ok", :entityId=>@classified.id } }
    end
  end
  private 
  def sort_column
    Classified.column_names.include?(params[:sort]) ? params[:sort] : "validuntil"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
