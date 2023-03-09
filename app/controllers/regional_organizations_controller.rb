
class RegionalOrganizationsController < AuthorityController
  before_action :set_regional_organization, only: [:show, :edit, :update, :destroy]
  # GET /regional_organizations
  # GET /regional_organizations.json
  before_action :authenticate_user!#, :except => [:index]

  authority_actions :orch=> 'read'
  authority_actions :share_overview => 'read'

  def index
    @regional_organizations = RegionalOrganizationAuthorizer.readable_by(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @regional_organizations }
    end
  end

  # GET /regional_organizations/1
  # GET /regional_organizations/1.json
  def show
    # set by before filter 
    authorize_action_for(@regional_organization)

	  @lastYear = Time.now.year-1

    @functions = Function.includes(:board_contact).where(:regional_organization_id=>@regional_organization.id)
    @functions_lv_filtered=true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @regional_organization }
    end
  end

  # GET /regional_organizations/new
  # GET /regional_organizations/new.json
  def new
    @regional_organization = RegionalOrganization.new
    @regional_organization.build_member

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @regional_organization }
    end
  end

  # GET /regional_organizations/1/edit
  def edit
    # set by before filter 
    authorize_action_for(@regional_organization)
  end

  # POST /regional_organizations
  # POST /regional_organizations.json
  def create
    @regional_organization = RegionalOrganization.new(params[:regional_organization])

    respond_to do |format|
      if @regional_organization.save
        format.html { redirect_to @regional_organization, :notice => 'Regional organization was successfully created.' }
        format.json { render :json => @regional_organization, :status => :created, :location => @regional_organization }
      else
        format.html { render :action => "new" }
        format.json { render :json => @regional_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regional_organizations/1
  # PUT /regional_organizations/1.json
  def update
    @regional_organization = RegionalOrganization.find(params[:id])

    respond_to do |format|
      @regional_organization.update(regional_organization_params)
      if @regional_organization.save
        format.html { redirect_to @regional_organization, :notice => 'Regional organization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @regional_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regional_organizations/1
  # DELETE /regional_organizations/1.json
  def destroy
    @regional_organization.destroy

    respond_to do |format|
      format.html { redirect_to regional_organizations_url }
      format.json { head :ok }
    end
  end

  def share_overview
    @regional_organizations = RegionalOrganizationAuthorizer.readable_by(current_user)
    authorize_action_for @regional_organizations.first
    @year = params[:year]

    if @year.nil? then
      @year = Time.now.year
    end

    if ( params[:before] != nil ) then
      @before = Date.strptime(params[:before],"%d.%m.%Y")
    else
      @before = Time.new
    end

    @regional_organization_shares = Array.new

    @s = Hash.new

    @s[:uv_sum]=0
    @s[:dd_uv_sum]=0
    @s[:lv_sum]=0
    @s[:lv_em_sum]=0
    @s[:lv_orch_sum]=0
    @s[:dd_em_sum]= 0
    @s[:dd_sum]= 0
    @s[:dd_uv_sum]= 0
    @s[:dd_orch_sum]= 0
    @s[:full_sum]= 0

    @regional_organizations.each do |ro|

      share = ro.member_fee_share_for_year(@year,@before)
      @s[:uv_sum]+=share[:uv]
      @s[:lv_sum]+=share[:orch_part]+share[:em_part]
      @s[:lv_em_sum]+=share[:em_part]
      @s[:lv_orch_sum]+=share[:orch_part]
      @s[:full_sum]+=share[:sum]
      @s[:dd_sum]+= share[:dd_em_part]+share[:dd_orch_part] 
      @s[:dd_em_sum]+= share[:dd_em_part]
      @s[:dd_orch_sum]+= share[:dd_orch_part]
      @s[:dd_uv_sum]+= share[:dd_uv] 

      @regional_organization_shares << share

    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_regional_organization
      @regional_organization = RegionalOrganization.find(params[:id])
    end

  def regional_organization_params
    #logger.debug(params.to_s)
    params.require(:regional_organization).permit( :nummer, :name, :subname, :homepage, :jugend_url,:gema_kdnr, :gema_kdnr_new,member_attributes: Member.nested_params )
  end
end
