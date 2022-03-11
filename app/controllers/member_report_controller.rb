class MemberReportController < AuthenticatedNonResourceController

  def index
	  authorize! :member, :edit
	  @sums = ReportSheet.select("year, count(*) as anzahl, sum(report_sheets.children) as sum_children , sum(report_sheets.teens) as sum_teens, sum(report_sheets.youth) as sum_youth ,sum(report_sheets.adult) as sum_adult, sum(report_sheets.senior) as sum_senior , sum(report_sheets.azubi) as sum_azubi, sum(report_sheets.passive) as sum_passive, sum(child_ens) as sum_child_ens, sum(youth_ens) as sum_youth_ens, sum(adult_ens) as sum_adult_ens, sum(senior_ens) as sum_senior_ens, sum(chamber_ens) as sum_chamber_ens, sum(other_ens) as sum_other_ens").group(:year).order(:year)

    @em_count = PersonMember.all.count

    sheets = ReportSheet.includes(:orchestra).group(:year).order(:year)
	
	  @l_orch_no_pay = sheets.where("orchestras.orch_type='L'").calculate(:sum,"children+teens+youth+adult+senior-azubi")
	  @l_orch_all= sheets.where("orchestras.orch_type='L'").calculate(:sum,"children+teens+youth+adult+senior")

	  @o_nomail = Orchestra.nomail.count()
	  @em_nomail = PersonMember.nomail.count()
	  @lorch = Hash.new

	  @vers_sums = Array.new
	  @vers_hash = Hash.new

	  @uv_sum = sheets.where("orchestras.orch_type<>'K' and uv=1").calculate(:sum,"children+teens+youth+adult+senior")

	  @uv_sum.each do |uv|
		  @vers_sums.push(uv[0])
		  h = Hash.new
		  h["uv"]=uv[1]
		  @vers_hash[uv[0]]=h 
	  end

	  @haft_sum = sheets.where("orchestras.orch_type='O'").calculate(:sum,"children+teens+youth+adult+senior")
	  @haft_sum.each do |hv|
		  vals = @vers_hash[hv[0]]
		  if (vals == nil ) then
        vals = Hash.new
        @vers_hash[hv[0]] = vals
		  end	

      vals["hv"]=hv[1]
	  end

	  @l_orch_all.each do |lv|
		  @lorch[lv[0]] = lv[1]
	  end

	  @orch_counts = Orchestra.group(:orch_type).count

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

  def report_sheet_stats
	  authorize! :member, :edit
    sheets = ReportSheet.final(Time.now.year).includes(:orchestra)

    @maxTariff = 0 
    @minTariff = 0

    sheets.each do |rs|
      if rs.calcBeitrag == Prices.maxTariff then
        @maxTariff+=1
      elsif rs.calcBeitrag == Prices.minTariff then
        @minTariff+=1
      end
    end


	  respond_to do |format|
      format.html
    end
  end
end
