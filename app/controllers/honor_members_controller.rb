class HonorMembersController < AuthenticatedController
  helper_method :sort_column, :sort_direction

  # GET /honor_members
  # GET /honor_members.json
  def index
    @honor_members = HonorMember.all.order(sort_column+ " "+ sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @honor_members }
    end
  end

  # GET /honor_members/1
  # GET /honor_members/1.json
  def show
    @honor_member = HonorMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @honor_member }
    end
  end

  # GET /honor_members/new
  # GET /honor_members/new.json
  def new
    @honor_member = HonorMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @honor_member }
    end
  end

  # GET /honor_members/1/edit
  def edit
    @honor_member = HonorMember.find(params[:id])
  end

  # POST /honor_members
  # POST /honor_members.json
  def create
    @honor_member = HonorMember.new(honor_member_params)

    respond_to do |format|
      if @honor_member.save
        format.html { redirect_to @honor_member, notice: 'Honor member was successfully created.' }
        format.json { render json: @honor_member, status: :created, location: @honor_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @honor_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /honor_members/1
  # PUT /honor_members/1.json
  def update
    @honor_member = HonorMember.find(params[:id])

    respond_to do |format|
      if @honor_member.update(honor_member_params)
        format.html { redirect_to @honor_member, notice: 'Honor member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @honor_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /honor_members/1
  # DELETE /honor_members/1.json
  def destroy
    @honor_member = HonorMember.find(params[:id])
    @honor_member.destroy

    respond_to do |format|
      format.html { redirect_to honor_members_url }
      format.json { head :no_content }
    end
  end

  private 
  def honor_member_params
    params.require(:honor_member).permit( :nr, :vorname, :name, :ort, :honorType, :honorDate,:deceased)
  end

  def sort_column
    valid = HonorMember.column_names.include?(params[:sort])
    logger.debug("valid col? #{params[:sort]}: #{valid}")
    valid ? params[:sort] : "nr"
  end
end
