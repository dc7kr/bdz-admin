require "rodf"

class RegionalOrganizationReportsController < AuthenticatedController
  include OrchestrasHelper

  #authority_actions orch: "read"
  #authority_actions index: "read"
  #authority_actions members: "read"
  #authority_actions fee_shares: "read"
  #authority_actions person: "read"
  
  before_action :set_regional_organization, only: %w[ index orchestras person_members members ]

  # nasty workaround for authority exception
  def search; end

  def index
    lv = RegionalOrganization.find(params[:regional_organization_id])
    @regional_organization = lv

    current_year = Time.zone.now.year
    orchestras = Orchestra.includes(:member).where(members: { regional_organization_id: lv.id }).order("members.mglnr")

    sheet = RegionalOrganizationOrchestrasSpreadsheet.new(@regional_organization, orchestras, year)
    sheet.render

    tmpname = "/tmp/lv#{lv.id}.ods"
    sheet.gen_file(tmpname)

    send_file(tmpname, filename: "lv_#{lv.id}.ods", type: "application/octet-stream")
  end

  def orchestras
    @orchestras = Orchestra.includes(:member).where(members: { regional_organization_id: params[:regional_organization_id] }).order("members.mglnr")
    respond_to do |format|
      format.ods do
        filename = "orch_lv#{@regional_organization.nummer}_#{Time.zone.now.year}.ods"
        sheet = RegionalOrganizationOrchestrasSpreadsheet.new(@regional_organization, @orchestras)
        sheet.render

        sheet.bytes
  
        send_data( sheet.bytes, filename: filename, type: "application/octet-stream")
      end
    end
  end

  def person_members
    @person_members = PersonMember.includes(:member).where(members: { regional_organization_id: params[:regional_organization_id] }).order("members.mglnr")
    respond_to do |format|
      format.ods do
        filename = "em_lv#{@regional_organization.nummer}_#{Time.zone.now.year}.ods"

        sheet = RegionalOrganizationPersonMembersSpreadsheet.new(@regional_organization, @person_members)
        sheet.render

        send_data( sheet.bytes, filename: filename, type: "application/octet-stream")
      end
    end
  end

  def members
    @year = params[:year]

    if @year.nil?
      @year = Time.zone.now.year
      Rails.logger.debug("Year is nil!")
    end

    @lvSum = 0
    @orchSum = 0
    @orchFullSum = 0
    @personSum = 0
    @orchestras = Orchestra.includes(%i[member report_sheets]).where("members.regional_organization_id =?",
                                                                     params[:regional_organization_id]).order("members.mglnr")
    @person_members = PersonMember.includes(:member, :tariff).where(members: { regional_organization_id: params[:regional_organization_id] }).order("members.mglnr")

    @ensembles = []

    @ens_sum = {}
    @ens_sum[:child_ens] = 0
    @ens_sum[:youth_ens] = 0
    @ens_sum[:adult_ens] = 0
    @ens_sum[:senior_ens] = 0
    @ens_sum[:chamber_ens] = 0
    @ens_sum[:total] = 0

    @orch_stats = {}
    @orch_stats[:children] = 0
    @orch_stats[:senior] = 0
    @orch_stats[:youth] = 0
    @orch_stats[:teens] = 0
    @orch_stats[:adult] = 0
    @orch_stats[:passive] = 0

    @orch_stats[:azubi_child] = 0
    @orch_stats[:azubi_teens] = 0
    @orch_stats[:azubi_youth] = 0
    @orch_stats[:azubi_adult] = 0
    @orch_stats[:azubi_senior] = 0

    @orchestras.each do |o|
      # lr = o.report_sheet_for_year(@year)
      lr = o.lastReportSheet
      ensemble = {}
      ensemble[:mglnr] = o.member.mglnr
      ensemble[:rs] = lr

      @ensembles << ensemble

      next if lr.nil?

      @ens_sum[:child_ens] += lr.child_ens unless lr.child_ens.nil?
      @ens_sum[:youth_ens] += lr.youth_ens unless lr.youth_ens.nil?
      @ens_sum[:adult_ens] += lr.adult_ens unless lr.adult_ens.nil?
      @ens_sum[:senior_ens] += lr.senior_ens unless lr.senior_ens.nil?
      @ens_sum[:chamber_ens] += lr.chamber_ens unless lr.chamber_ens.nil?
      @ens_sum[:total] += lr.total_ensembles
      @orch_stats[:children] += lr.children
      @orch_stats[:teens] += lr.teens
      @orch_stats[:youth] += lr.youth
      @orch_stats[:adult] += lr.adult
      @orch_stats[:senior] += lr.senior
      lr.update_stats(@orch_stats, :azubi_child, lr.azubi_child)
      lr.update_stats(@orch_stats, :azubi_teens, lr.azubi_teens)
      lr.update_stats(@orch_stats, :azubi_youth, lr.azubi_youth)
      lr.update_stats(@orch_stats, :azubi_adult, lr.azubi_adult)
      lr.update_stats(@orch_stats, :azubi_senior, lr.azubi_senior)
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = RegionalOrganizationPdf.new(@regional_organization, @orchestras, @person_members, @year, view_context)
        send_data pdf.render, filename: "lv_#{@regional_organization.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
      format.csv
    end
  end

  def fee_shares
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize @regional_organization

    @lvSum = 0
    @orchSum = 0
    @orchFullSum = 0
    @personSum = 0
    @orchestras = Orchestra.includes(%i[member report_sheets]).where("members.regional_organization_id =?",
                                                                     params[:regional_organization_id]).order("members.mglnr")
    @person_members = PersonMember.includes(:member, :tariff).where(members: { regional_organization_id: params[:regional_organization_id] }).order("members.mglnr")

    respond_to do |format|
      format.pdf do
        pdf = RegionalOrganizationFeeSharePdf.new(@regional_organization, @orchestras, @person_members, view_context)
        send_data pdf.render, filename: "beitragsanteile_lv_#{@regional_organization.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def oddset_report
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])
    @report_sheets = ReportSheet.find_by_sql([
                                               "SELECT rs.* FROM report_sheets rs, members m WHERE rs.orchestra_id=m.id AND m.regional_organization_id = ? AND year = ?", params[:regional_organization_id], params[:year]
                                             ])

    @sums = { orchestras: 0, passive: 0, active: 0, youth: 0 }
    @report_sheets.each do |r|
      @sums[:orchestras] += 1
      @sums[:passive] += r.passive
      @sums[:active] += r.totalActiveMembers
      @sums[:youth] += r.children + r.teens + r.youth
    end
  end

  def share_overview
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize @regional_organization

    @year = params[:year]

    @year = Time.zone.now.year if @year.nil?

    @before = if params[:before].nil?
                Time.zone.now
    else
                Date.strptime(params[:before], "%d.%m.%Y")
    end

    @regional_organization_shares = []

    @s = {}

    @s[:uv_sum] = 0
    @s[:dd_uv_sum] = 0
    @s[:lv_sum] = 0
    @s[:lv_em_sum] = 0
    @s[:lv_orch_sum] = 0
    @s[:dd_em_sum] = 0
    @s[:dd_sum] = 0
    @s[:dd_orch_sum] = 0
    @s[:full_sum] = 0

    @regional_organizations.each do |ro|
      share = ro.member_fee_share_for_year(@year, @before)
      @s[:uv_sum] += share[:uv]
      @s[:lv_sum] += share[:orch_part] + share[:em_part]
      @s[:lv_em_sum] += share[:em_part]
      @s[:lv_orch_sum] += share[:orch_part]
      @s[:full_sum] += share[:sum]
      @s[:dd_sum] += share[:dd_em_part] + share[:dd_orch_part]
      @s[:dd_em_sum] += share[:dd_em_part]
      @s[:dd_orch_sum] += share[:dd_orch_part]
      @s[:dd_uv_sum] = share[:dd_uv]

      @regional_organization_shares << share
    end
  end

  private
  def set_regional_organization
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize [:report, @regional_organization ]
  end

end
