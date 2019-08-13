class HomepagesController < AuthorityController
  authorize_actions_for Homepage, :except => :create 

  authority_actions :future=> 'read', :inactive => 'read', :publish=> 'update'

  before_action :set_homepage, only: [:show, :edit, :update, :destroy]

  #, :actions => {:neuter => :update},
  # GET /homepages
  # GET /homepages.json
  def index
    @homepages = Homepage.page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @homepages }
    end
  end

  # GET /homepages/1
  # GET /homepages/1.json
  def show
    @homepage = Homepage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @homepage }
    end
  end

  # GET /homepages/new
  # GET /homepages/new.json
  def new
    @homepage = Homepage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @homepage }
    end
  end

  # GET /homepages/1/edit
  def edit
    @homepage = Homepage.find(params[:id])
  end

  # POST /homepages
  # POST /homepages.json
  def create
    @homepage = Homepage.new(homepage_params)

    respond_to do |format|
      if @homepage.save
        format.html { redirect_to @homepage, notice: 'Homepage was successfully created.' }
        format.json { render json: @homepage, status: :created, location: @homepage }
      else
        format.html { render action: "new" }
        format.json { render json: @homepage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /homepages/1
  # PUT /homepages/1.json
  def update
    @homepage = Homepage.find(params[:id])

    respond_to do |format|
      if @homepage.update_attributes(homepage_params)
        format.html { redirect_to @homepage, notice: 'Homepage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @homepage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homepages/1
  # DELETE /homepages/1.json
  def destroy
    @homepage = Homepage.find(params[:id])
    @homepage.destroy

    respond_to do |format|
      format.html { redirect_to homepages_url }
      format.json { head :no_content }
    end
  end


  def set_homepage
    @homepage = Homepage.find(params[:id])

    authorize_action_for @homepage
  end


  def homepage_params
    params.require(:homepage).permit( :abbrev, :mitglnr, :name, :kontakt, :proben, :descr, :redir_url)
  end
end
