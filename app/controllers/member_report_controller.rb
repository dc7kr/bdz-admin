class MemberReportController < AuthenticatedController
  def index
    @sums = policy_scope(ReportSheet).select("year, count(*) as anzahl, sum(report_sheets.children) as sum_children , sum(report_sheets.teens) as sum_teens, sum(report_sheets.youth) as sum_youth ,sum(report_sheets.adult) as sum_adult, sum(report_sheets.senior) as sum_senior , sum(report_sheets.azubi) as sum_azubi, sum(report_sheets.passive) as sum_passive, sum(child_ens) as sum_child_ens, sum(youth_ens) as sum_youth_ens, sum(adult_ens) as sum_adult_ens, sum(senior_ens) as sum_senior_ens, sum(chamber_ens) as sum_chamber_ens, sum(other_ens) as sum_other_ens").group(:year).order(:year)

    @em_count = policy_scope(PersonMember).count

    sheets = policy_scope(ReportSheet).includes(:orchestra).group(:year).order(:year)

    @l_orch_no_pay = sheets.where("orchestras.orch_type='L'").calculate(:sum,
                                                                        "children+teens+youth+adult+senior-azubi")
    @l_orch_all = sheets.where("orchestras.orch_type='L'").calculate(:sum, "children+teens+youth+adult+senior")

    @o_nomail = policy_scope(Orchestra).nomail.count
    @em_nomail = policy_scope(PersonMember).nomail.count
    @lorch = {}

    @vers_sums = []
    @vers_hash = {}

    @uv_sum = sheets.where("orchestras.orch_type<>'K' and uv=1").calculate(:sum, "children+teens+youth+adult+senior")

    @uv_sum.each do |uv|
      @vers_sums.push(uv[0])
      h = {}
      h["uv"] = uv[1]
      @vers_hash[uv[0]] = h
    end

    @haft_sum = sheets.where("orchestras.orch_type='O'").calculate(:sum, "children+teens+youth+adult+senior")
    @haft_sum.each do |hv|
      vals = @vers_hash[hv[0]]
      if vals.nil?
        vals = {}
        @vers_hash[hv[0]] = vals
      end

      vals["hv"] = hv[1]
    end

    @l_orch_all.each do |lv|
      @lorch[lv[0]] = lv[1]
    end

    @orch_counts = policy_scope(Orchestra).group(:orch_type).count

    respond_to do |format|
      format.html
      format.json do
        render json: @sums.to_json
      end
    end
  end

  def by_lv
    if params[:year].nil?
      Time.zone.now.year.to_s
    else
      params[:year]
    end

    @sums = policy_scope(ReportSheet).query("SELECT rs.*,m.regional_organization_id from report_sheets rs,members m where rs.orchestra_id=m.id and year=? GROUP BY m.regional_organization_id")

    @sums = policy_scope(ReportSheet).includes(%i[orchestra member]).all(
      select: "year, count(*) as anzahl, sum(report_sheets.children) as sum_children , sum(report_sheets.teens) as sum_teens, sum(report_sheets.youth) as sum_youth ,sum(report_sheets.adult) as sum_adult, sum(report_sheets.senior) as sum_senior , sum(report_sheets.azubi) as sum_azubi, sum(report_sheets.passive) as sum_passive", order: "member.regional_organization", group: "year"
    )
  end

  def report_sheet_stats
    sheets = policy_scope(ReportSheet).final(Time.zone.now.year).includes(:orchestra)

    @maxTariff = 0
    @minTariff = 0

    sheets.each do |rs|
      if rs.calcBeitrag == Prices.maxTariff
        @maxTariff += 1
      elsif rs.calcBeitrag == Prices.minTariff
        @minTariff += 1
      end
    end

    respond_to do |format|
      format.html
    end
  end


  protected
  def index_actions
    super.append(:by_lv, :report_sheet_stats)
  end

end
