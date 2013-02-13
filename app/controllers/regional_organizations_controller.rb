
class RegionalOrganizationsController < ApplicationController
  # GET /regional_organizations
  # GET /regional_organizations.json
  before_filter :authenticate_user!#, :except => [:index]
  load_and_authorize_resource

  def index
    @regional_organizations = RegionalOrganization.all

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

  def orch
	@orchestras = Orchestra.includes(:member).where("members.regional_organization_id = ?", params[:id]).order("members.mglnr")
	respond_to do |format|
		format.csv { render :csv => @orchestras, :style=>:lv, :filename => "orch_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	end
  end

  def person
	@person_members = PersonMember.includes(:member).where("members.regional_organization_id = ?", params[:id]).order("members.mglnr").to_comma(:lv)
	respond_to do |format|
		format.csv { render :csv => @person_members, :style=>:lv, :filename => "em_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	end
  end
 
  def members 
    @regional_organization = RegionalOrganization.find(params[:id])
	@lvSum=0
	@orchSum=0
	@personSum=0
	@orchestras =  Orchestra.includes([:member,:report_sheets]).where('members.regional_organization_id =?',params[:id]).order('members.mglnr')
	@person_members = PersonMember.includes(:member,:tariff).where('members.regional_organization_id = ?',params[:id]).order('members.mglnr')

	respond_to do |format|
		format.html 
		format.pdf do
			pdf = RegionalOrganizationPdf.new(@regional_organization,@orchestras,@person_members,view_context)
			send_data pdf.render, filename: "lv_#{@regional_organization.id}.pdf",
				type: "application/pdf",
				disposition: "inline"
		end
		format.csv 
	end
  end


  def create_final_payment
	lvs = @RegionalOrganization.all

	lvs.each do |lv|
		
	end
  end

  def oddset_report
	@report_sheets = ReportSheet.find_by_sql(["SELECT rs.* FROM report_sheets rs, members m WHERE rs.orchestra_id=m.id AND m.regional_organization_id = ? AND year = ?",params[:id],params[:year]])


	@sums = { :orchestras => 0, :passive =>0, :active => 0, :youth =>0 } 
	@report_sheets.each do |r|
		@sums[:orchestras]+=1
		@sums[:passive]+=r.passive
		@sums[:active]+=r.totalActiveMembers
		@sums[:youth]+=r.children+r.teens+r.youth
	end
  end
end
