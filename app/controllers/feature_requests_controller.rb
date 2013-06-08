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

  # GET /feature_requests/1
  # GET /feature_requests/1.json
  def show
    @feature_request = FeatureRequest.find(params[:id])

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
    @feature_request = FeatureRequest.new(params[:feature_request])

    respond_to do |format|
      if @feature_request.save
        format.html { redirect_to @feature_request, notice: 'Feature request was successfully created.' }
        format.json { render json: @feature_request, status: :created, location: @feature_request }
      else
        format.html { render action: "new" }
        format.json { render json: @feature_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feature_requests/1
  # PUT /feature_requests/1.json
  def update
    @feature_request = FeatureRequest.find(params[:id])

    respond_to do |format|
      if @feature_request.update_attributes(params[:feature_request])
        format.html { redirect_to @feature_request, notice: 'Feature request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
end
