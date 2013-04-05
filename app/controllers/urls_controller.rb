class UrlsController < AuthenticatedController

  # for table sort by column click
  helper_method :sort_column, :sort_direction

  # GET /urls
  # GET /urls.json
  before_filter :authenticate_user!#, :except => [:index]
  
  def inactive 
    @urls = Url.inactive.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @urls }
    end
  end

  def confirm
	@url = Url.find(params[:id])

	@url.confirmed = Time.now
	@url.visible= true
	@url.save
    redirect_to urls_path(@url), :notice => t('urls.confirm_success')
  end

  def index
    @urls = Url.search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(30)



    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @urls }
	  format.js
    end
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    @url = Url.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @url }
    end
  end

  # GET /urls/new
  # GET /urls/new.json
  def new
    @url = Url.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @url }
    end
  end

  # GET /urls/1/edit
  def edit
    @url = Url.find(params[:id])
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(params[:url])

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, :notice => 'Url was successfully created.' }
        format.json { render :json => @url, :status => :created, :location => @url }
      else
        format.html { render :action => "new" }
        format.json { render :json => @url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /urls/1
  # PUT /urls/1.json
  def update
    @url = Url.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(params[:url])
        format.html { redirect_to @url, :notice => 'Url was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :ok }
    end
  end


  private 
  def sort_column
    Url.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
end
