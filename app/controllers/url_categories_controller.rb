class UrlCategoriesController < PublicEntitiesController
  # GET /url_categories
  # GET /url_categories.json
  before_action :authenticate_user! # , :except => [:index]
  def index
    @url_categories = UrlCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @url_categories }
    end
  end

  # GET /url_categories/1
  # GET /url_categories/1.json
  def show
    @url_category = UrlCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @url_category }
    end
  end

  # GET /url_categories/new
  # GET /url_categories/new.json
  def new
    @url_category = UrlCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @url_category }
    end
  end

  # GET /url_categories/1/edit
  def edit
    @url_category = UrlCategory.find(params[:id])
  end

  # POST /url_categories
  # POST /url_categories.json
  def create
    @url_category = UrlCategory.new(params[:url_category])

    respond_to do |format|
      if @url_category.save
        format.html { redirect_to @url_category, notice: "Url category was successfully created." }
        format.json { render json: @url_category, status: :created, location: @url_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @url_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /url_categories/1
  # PUT /url_categories/1.json
  def update
    @url_category = UrlCategory.find(params[:id])

    respond_to do |format|
      if @url_category.update(params[:url_category])
        format.html { redirect_to @url_category, notice: "Url category was successfully updated." }
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @url_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /url_categories/1
  # DELETE /url_categories/1.json
  def destroy
    @url_category = UrlCategory.find(params[:id])
    @url_category.destroy

    respond_to do |format|
      format.html { redirect_to url_categories_url }
      format.json { head :ok }
    end
  end

  private  
  # Use callbacks to share common setup or constraints between actions.
  def set_url_category
    @url_category = policy_scope(UrlCategory).find(params[:id])
    authorize @url_category
  end

end
