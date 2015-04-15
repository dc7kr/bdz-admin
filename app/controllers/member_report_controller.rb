class MemberReportController < AuthenticatedNonResourceController

  def index
	  authorize! :member, :edit
	  @sums = ReportSheet.all(:select => "year, count(*) as anzahl, sum(report_sheets.children) as sum_children , sum(report_sheets.teens) as sum_teens, sum(report_sheets.youth) as sum_youth ,sum(report_sheets.adult) as sum_adult, sum(report_sheets.senior) as sum_senior , sum(report_sheets.azubi) as sum_azubi, sum(report_sheets.passive) as sum_passive", :order => "year", :group => "year")

    @em_count = PersonMember.all.count

	
	  @l_orch_no_pay = ReportSheet.includes(:orchestra).calculate(:sum,"children+teens+youth+adult+senior-azubi",:conditions => "orchestras.orch_type='L'",:group=>"year",:order=>"year")
	  @l_orch_all= ReportSheet.includes(:orchestra).calculate(:sum,"children+teens+youth+adult+senior",:conditions => "orchestras.orch_type='L'",:group=>"year",:order=>"year")

	  @o_nomail = Orchestra.includes(:member).nomail.count()
	  @em_nomail = PersonMember.includes(:member).nomail.count()
	  @lorch = Hash.new

	  @vers_sums = Array.new
	  @vers_hash = Hash.new

	  @uv_sum = ReportSheet.includes(:orchestra).calculate(:sum,"children+teens+youth+adult+senior",:group=>"year",:conditions=>"orchestras.orch_type<>'K' and uv=1",:order=>"year")

	  @uv_sum.each do |uv|
		  @vers_sums.push(uv[0])
		  h = Hash.new
		  h["uv"]=uv[1]
		  @vers_hash[uv[0]]=h 
	  end

	  @haft_sum = ReportSheet.includes(:orchestra).calculate(:sum,"children+teens+youth+adult+senior",:group=>"year",:order=>"year",:conditions=>"orchestras.orch_type='O'")
	  @haft_sum.each do |hv|
		  vals = @vers_hash[hv[0]]
		  if (vals != nil ) then
			  vals["hv"]=hv[1]
		  end
	  end

	  @haft_sum = ReportSheet.includes(:orchestra).calculate(:sum,"children+teens+youth+adult+senior-azubi",:group=>"year",:order=>"year",:conditions=>"orchestras.orch_type='L'")


	  @haft_sum.each do |hv|
		  vals = @vers_hash[hv[0]]
		  vals["hv"]+=hv[1]
  	end

	  @l_orch_all.each do |lv|
		  @lorch[lv[0]] = lv[1]
	  end

	  @orch_counts = Orchestra.count(nil,:group=>'orch_type')

	  respond_to do |format|
      format.html
      format.json { 
        render :json => @sums.to_json
      }
    end
  end

  def by_lv
	  authorize! :member, :edit
    year = nil
    if params[:year].nil?
      year = Time.now.year.to_s
    else
      year = params[:year]  
    end

    @sums = ReportSheet.query("SELECT rs.*,m.regional_organization_id from report_sheets rs,members m where rs.orchestra_id=m.id and year=? GROUP BY m.regional_organization_id")
 
	  @sums = ReportSheet.includes([:orchestra,:member]).all(:select => "year, count(*) as anzahl, sum(report_sheets.children) as sum_children , sum(report_sheets.teens) as sum_teens, sum(report_sheets.youth) as sum_youth ,sum(report_sheets.adult) as sum_adult, sum(report_sheets.senior) as sum_senior , sum(report_sheets.azubi) as sum_azubi, sum(report_sheets.passive) as sum_passive", :order => "member.regional_organization", :group => "year")
  end
end
