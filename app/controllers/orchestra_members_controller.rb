class OrchestraMembersController < AuthenticatedController

  helper_method :sort_column, :sort_direction

  # GET /orchestra_members
  # GET /orchestra_members.json
  def index
    @orchestra_members = OrchestraMember.where("orchestra_id = ?", params[:orchestra_id]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)


	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orchestra_members }
    end
  end

  # GET /orchestra_members/1
  # GET /orchestra_members/1.json
  def show
    @orchestra_member = OrchestraMember.find(params[:id])
	
	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orchestra_member }
    end
  end

  # GET /orchestra_members/new
  # GET /orchestra_members/new.json
  def new
    @orchestra_member = OrchestraMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orchestra_member }
    end
  end

  # GET /orchestra_members/1/edit
  def edit
    @orchestra_member = OrchestraMember.find(params[:id])
  end

  # POST /orchestra_members
  # POST /orchestra_members.json
  def create
    @orchestra_member = OrchestraMember.new(params[:orchestra_member])

    respond_to do |format|
      if @orchestra_member.save
        format.html { redirect_to @orchestra_member, notice: 'Orchestra member was successfully created.' }
        format.json { render json: @orchestra_member, status: :created, location: @orchestra_member }
      else
        format.html { render action: "new" }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestra_members/1
  # PUT /orchestra_members/1.json
  def update
    @orchestra_member = OrchestraMember.find(params[:id])

    respond_to do |format|
      if @orchestra_member.update_attributes(params[:orchestra_member])
        format.html { redirect_to @orchestra_member, notice: 'Orchestra member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orchestra_members/1
  # DELETE /orchestra_members/1.json
  def destroy
    @orchestra_member = OrchestraMember.find(params[:id])
    @orchestra_member.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_members_url }
      format.json { head :no_content }
    end
  end

  #########################
  # PRIVATE METHODS
  #########################
  private 
  def sort_column
    OrchestraMember.column_names.include?(params[:sort]) ? params[:sort] : "last_name,first_name"
  end
end
