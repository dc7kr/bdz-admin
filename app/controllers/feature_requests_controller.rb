class FeatureRequestsController < AuthenticatedController
  # GET /feature_requests
  # GET /feature_requests.json
  def index
    @feature_requests = FeatureRequest.order([:priority,:title])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feature_requests }
    end
  end

  def open
    @feature_requests = FeatureRequest.order([:priority,:title]).where("status <> 'D'");

    respond_to do |format|
      format.html { render "index" }# index.html.erb
      format.json { render json: @feature_requests }
    end
  end

  # GET /feature_requests/1
  # GET /feature_requests/1.json
  def show
    @feature_request = FeatureRequest.includes(:user).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature_request }
    end
  end

  # GET /feature_requests/new
  # GET /feature_requests/new.json
  def new
    @feature_request = FeatureRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature_request }
    end
  end

  # GET /feature_requests/1/edit
  def edit
    @feature_request = FeatureRequest.find(params[:id])
  end

  # POST /feature_requests
  # POST /feature_requests.json
  def create
    @feature_request = FeatureRequest.new(feature_request_params)
    @feature_request.user = current_user

    respond_to do |format|
      if @feature_request.save
        format.html { redirect_to @feature_request, notice: 'Feature request was successfully created.' }
        format.json { render json: @feature_request, status: :created, location: @feature_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feature_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feature_requests/1
  # PUT /feature_requests/1.json
  def update
    @feature_request = FeatureRequest.find(params[:id])

    if not current_user.admin? and feature_request.user_id != user.id then
        format.html { redirect_to @feature_request, error: 'Permission denied.' }
    end

    respond_to do |format|
      if @feature_request.update(feature_request_params)
        format.html { redirect_to @feature_request, error: 'Feature request successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feature_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feature_requests/1
  # DELETE /feature_requests/1.json
  def destroy
    @feature_request = FeatureRequest.find(params[:id])
    @feature_request.destroy

    respond_to do |format|
      format.html { redirect_to feature_requests_url }
      format.json { head :no_content }
    end
  end

  def feature_request_params
    params.require(:feature_request).permit(:title,:description,:status,:priority,:user_id)
  end
end
