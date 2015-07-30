
class RegionalOrganizationsController < AuthenticatedController
  # GET /regional_organizations
  # GET /regional_organizations.json
  before_filter :authenticate_user!#, :except => [:index]
  load_and_authorize_resource

  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @regional_organizations }
    end
  end

  # GET /regional_organizations/1
  # GET /regional_organizations/1.json
  def show

	  @lastYear = Time.now.year-1
    @regional_organization = RegionalOrganization.find(params[:id])


    @functions = Function.includes(:board_contact).where(:regional_organization_id=>@regional_organization.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @regional_organization }
    end
  end

  # GET /regional_organizations/new
  # GET /regional_organizations/new.json
  def new
    @regional_organization = RegionalOrganization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @regional_organization }
    end
  end

  # GET /regional_organizations/1/edit
  def edit
    @regional_organization = RegionalOrganization.find(params[:id])
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
      if @regional_organization.update_attributes(params[:regional_organization])
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
    @regional_organization = RegionalOrganization.find(params[:id])
    @regional_organization.destroy

    respond_to do |format|
      format.html { redirect_to regional_organizations_url }
      format.json { head :ok }
    end
  end
end
