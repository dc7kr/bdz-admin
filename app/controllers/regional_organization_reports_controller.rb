require 'odf/spreadsheet'

class RegionalOrganizationReportsController < AuthenticatedNonResourceController
  include OrchestrasHelper
  load_and_authorize_resource :regional_organization

  def index
    lv = RegionalOrganization.find(params[:regional_organization_id])
    @regional_organization = lv

    current_year = Time.now.year
    orchestras = Orchestra.includes(:member).where("members.regional_organization_id = ?", lv.id).order("members.mglnr")

    tmpname = "/tmp/lv#{lv.id}.ods"
    ODF::Spreadsheet.file(tmpname) do 
      table 'Orchester' do |t|
        t.row do 
          cell "Mglnr"
          cell "Name"
          cell "Email"
          cell I18n.t("orchestra_contact.role_V")
          cell I18n.t("orchestra_contact.role_S")
          cell I18n.t("orchestra_contact.role_G")
          cell I18n.t("orchestra_contact.role_D")
          cell I18n.t("orchestra_contact.role_J")
          cell I18n.t("orchestra_contact.role_O")
        end
          orchestras.each do |o|
            oc = o.contacts_by_role
            t.row do 
              cell o.mglnr
              cell o.orchName
              cell o.email
              cell oc['V'].to_s
              cell oc['S'].to_s
              cell oc['G'].to_s
              cell oc['D'].to_s
              cell oc['J'].to_s
              cell oc['O'].to_s
            end
          end
      end
      table 'Orchester-Statistik' do |t|
        t.row do 
          cell "Mglnr"
          cell I18n.t('report_sheet.total_active')
          cell I18n.t('report_sheet.passive')
          cell I18n.t('report_sheet.child_ens')
          cell I18n.t('report_sheet.youth_ens')
          cell I18n.t('report_sheet.adult_ens')
          cell I18n.t('report_sheet.senior_ens')
          cell I18n.t('report_sheet.chamber_ens')
        end
        orchestras.each do |o|
          rs = o.report_sheet_for_year(year)
          t.row do 
            cell o.mglnr
            cell o.orchName
            cell rs.totalActiveMembers
            cell rs.passive
            cell rs.child_ens.to_i,  :type => :float
            cell rs.youth_ens.to_i, :type => :float
            cell rs.adult_ens.to_i, :type => :float
            cell rs.senior_ens.to_i, :type => :float
            cell rs.chamber_ens.to_i, :type => :float
            cell rs.total_ensembles, :type => :float
            if ( rs.year != current_year) then
              cell "(Meldebogen #{rs.year})"
            end
          end
        end
      end
    end
    send_file(tmpname, :filename => "lv_#{lv.id}.ods", :type => "application/octet-stream")    
  end


  def orch
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])

  	@orchestras = Orchestra.includes(:member).where("members.regional_organization_id = ?", params[:regional_organization_id]).order("members.mglnr")
	  respond_to do |format|
		  format.csv { render :csv => @orchestras, :style=>:lv, :filename => "orch_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	  end
  end

  def person
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])
	  @person_members = PersonMember.includes(:member).where("members.regional_organization_id = ?", params[:regional_organization_id]).order("members.mglnr")
	  respond_to do |format|
		  format.csv { render :csv => @person_members, :style=>:lv, :filename => "em_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	  end
  end


  def members 

    @year = params[:year]

    if @year.nil? then
      @year = Time.now.year
      Rails.logger.debug("Year is nil!")
    end

    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
	  @lvSum=0
	  @orchSum=0
	  @orchFullSum=0
	  @personSum=0
	  @orchestras =  Orchestra.includes([:member,:report_sheets]).where('members.regional_organization_id =?',params[:regional_organization_id]).order('members.mglnr')
	  @person_members = PersonMember.includes(:member,:tariff).where('members.regional_organization_id = ?',params[:regional_organization_id]).order('members.mglnr')

    @ensembles = Array.new

    @ens_sum = Hash.new 
    @ens_sum[:child_ens ] =  0 
    @ens_sum[:youth_ens] = 0
		@ens_sum[:adult_ens] = 0
    @ens_sum[:senior_ens] = 0
    @ens_sum[:chamber_ens] = 0
    @ens_sum[:total] = 0 
  
    @orchestras.each do |o|
      lr = o.report_sheet_for_year(@year)
      ensemble = Hash.new 
      ensemble[:mglnr] =o.mglnr
      ensemble[:rs] = lr 

      @ensembles << ensemble

      if not lr.nil? then
        @ens_sum[:child_ens]+=lr.child_ens unless lr.child_ens.nil?
        @ens_sum[:youth_ens]+=lr.youth_ens unless lr.youth_ens.nil?
        @ens_sum[:adult_ens]+=lr.adult_ens unless lr.adult_ens.nil?
        @ens_sum[:senior_ens]+=lr.senior_ens unless lr.senior_ens.nil?
        @ens_sum[:chamber_ens]+=lr.chamber_ens unless lr.chamber_ens.nil?
        @ens_sum[:total]+=lr.total_ensembles
      end
    end
      
	  respond_to do |format|
		  format.html 
		  format.pdf do
			  pdf = RegionalOrganizationPdf.new(@regional_organization,@orchestras,@person_members,@year,view_context)
			  send_data pdf.render, filename: "lv_#{@regional_organization.id}.pdf",
				  type: "application/pdf",
			  	disposition: "inline"
		  end
		  format.csv 
	  end
  end

  def fee_shares
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
	  @lvSum=0
	  @orchSum=0
	  @orchFullSum=0
	  @personSum=0
	  @orchestras =  Orchestra.includes([:member,:report_sheets]).where('members.regional_organization_id =?',params[:regional_organization_id]).order('members.mglnr')
	  @person_members = PersonMember.includes(:member,:tariff).where('members.regional_organization_id = ?',params[:regional_organization_id]).order('members.mglnr')

	  respond_to do |format|
		  format.pdf do
			  pdf = RegionalOrganizationFeeSharePdf.new(@regional_organization,@orchestras,@person_members,view_context)
			  send_data pdf.render, filename: "beitragsanteile_lv_#{@regional_organization.id}.pdf",
				  type: "application/pdf",
			  	disposition: "inline"
		  end
    end
  end


  def oddset_report
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])
  	@report_sheets = ReportSheet.find_by_sql(["SELECT rs.* FROM report_sheets rs, members m WHERE rs.orchestra_id=m.id AND m.regional_organization_id = ? AND year = ?",params[:regional_organization_id],params[:year]])


	@sums = { :orchestras => 0, :passive =>0, :active => 0, :youth =>0 } 
	@report_sheets.each do |r|
		@sums[:orchestras]+=1
		@sums[:passive]+=r.passive
		@sums[:active]+=r.totalActiveMembers
		@sums[:youth]+=r.children+r.teens+r.youth
	end
  end

  def share_overview
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])
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
		@s[:dd_uv_sum]= share[:dd_uv] 

		@regional_organization_shares << share

	end
  end
end
