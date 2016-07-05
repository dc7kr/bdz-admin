
module RegionalOrganizationReport


  private
  def orch
  	@orchestras = Orchestra.includes(:member).where("members.regional_organization_id = ?", params[:id]).order("members.mglnr")
	  respond_to do |format|
		  format.csv { render :csv => @orchestras, :style=>:lv, :filename => "orch_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	  end
  end

  private 
  def person
	  @person_members = PersonMember.includes(:member).where("members.regional_organization_id = ?", params[:id]).order("members.mglnr")
	  respond_to do |format|
		  format.csv { render :csv => @person_members, :style=>:lv, :filename => "em_lv"+@regional_organization.nummer.to_s+"_"+Time.now.year.to_s }
	  end
  end


  private 
  def members 
    @regional_organization = RegionalOrganization.find(params[:id])
	  @lvSum=0
	  @orchSum=0
	  @orchFullSum=0
	  @personSum=0
	  @orchestras =  Orchestra.includes([:member,:report_sheets]).where('members.regional_organization_id =?',params[:id]).order('members.mglnr')
	  @person_members = PersonMember.includes(:member,:tariff).where('members.regional_organization_id = ?',params[:id]).order('members.mglnr')

    @ensembles = Array.new

    @ens_sum = Hash.new 
    @ens_sum[:child_ens ] =  0 
    @ens_sum[:youth_ens] = 0
		@ens_sum[:adult_ens] = 0
    @ens_sum[:senior_ens] = 0
    @ens_sum[:chamber_ens] = 0
    @ens_sum[:total] = 0 
  
    @orchestras.each do |o|
      lr = o.report_sheet_for_year(year)
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
			  pdf = RegionalOrganizationPdf.new(@regional_organization,@orchestras,@person_members,view_context)
			  send_data pdf.render, filename: "lv_#{@regional_organization.id}.pdf",
				  type: "application/pdf",
			  	disposition: "inline"
		  end
		  format.csv 
	  end
  end

  private
  def fee_shares
    @regional_organization = RegionalOrganization.find(params[:id])
	  @lvSum=0
	  @orchSum=0
	  @orchFullSum=0
	  @personSum=0
	  @orchestras =  Orchestra.includes([:member,:report_sheets]).where('members.regional_organization_id =?',params[:id]).order('members.mglnr')
	  @person_members = PersonMember.includes(:member,:tariff).where('members.regional_organization_id = ?',params[:id]).order('members.mglnr')

	  respond_to do |format|
		  format.pdf do
			  pdf = RegionalOrganizationFeeSharePdf.new(@regional_organization,@orchestras,@person_members,view_context)
			  send_data pdf.render, filename: "beitragsanteile_lv_#{@regional_organization.id}.pdf",
				  type: "application/pdf",
			  	disposition: "inline"
		  end
    end
  end


  private
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

  private 
  def share_overview
    @curYear = Time.now.year

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

    share = ro.member_fee_share_for_year(@curYear,@before)
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
