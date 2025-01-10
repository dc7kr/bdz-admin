require 'rodf'

class RegionalOrganizationReportsController < AuthorityController
  include OrchestrasHelper

  authority_actions orch: 'read'
  authority_actions index: 'read'
  authority_actions members: 'read'
  authority_actions fee_shares: 'read'
  authority_actions person: 'read'

  def index
    lv = RegionalOrganization.find(params[:regional_organization_id])
    @regional_organization = lv

    current_year = Time.now.year
    orchestras = Orchestra.includes(:member).where('members.regional_organization_id = ?', lv.id).order('members.mglnr')

    tmpname = "/tmp/lv#{lv.id}.ods"
    RODF::Spreadsheet.file(tmpname) do
      table 'Orchester' do |t|
        t.row do
          cell 'Mglnr'
          cell 'Name'
          cell 'Email'
          cell I18n.t('orchestra_contact.role_V')
          cell I18n.t('orchestra_contact.role_S')
          cell I18n.t('orchestra_contact.role_G')
          cell I18n.t('orchestra_contact.role_D')
          cell I18n.t('orchestra_contact.role_J')
          cell I18n.t('orchestra_contact.role_O')
        end
        orchestras.each do |o|
          oc = o.contacts_by_role
          o.lastReportSheet

          t.row do
            cell o.member.mglnr
            cell o.orchName
            cell o.member.email
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
          cell 'Mglnr'
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
            cell rs.child_ens.to_i, type: :float
            cell rs.youth_ens.to_i, type: :float
            cell rs.adult_ens.to_i, type: :float
            cell rs.senior_ens.to_i, type: :float
            cell rs.chamber_ens.to_i, type: :float
            cell rs.total_ensembles, type: :float
            cell "(Meldebogen #{rs.year})" if rs.year != current_year
          end
        end
      end
    end
    send_file(tmpname, filename: "lv_#{lv.id}.ods", type: 'application/octet-stream')
  end

  def orch
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize_action_for @regional_organization

    @orchestras = Orchestra.includes(:member).where('members.regional_organization_id = ?',
                                                    params[:regional_organization_id]).order('members.mglnr')
    respond_to do |format|
      format.ods do
        filename = 'orch_lv' + @regional_organization.nummer.to_s + '_' + Time.now.year.to_s + '.ods'
        renderOrchOds('/tmp/' + filename, @orchestras)
        send_file('/tmp/' + filename, filename: filename, type: 'application/octet-stream')
      end
    end
  end

  def person
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize_action_for @regional_organization

    @person_members = PersonMember.includes(:member).where('members.regional_organization_id = ?',
                                                           params[:regional_organization_id]).order('members.mglnr')
    respond_to do |format|
      format.ods do
        filename = 'em_lv' + @regional_organization.nummer.to_s + '_' + Time.now.year.to_s + '.ods'
        render_person_members_ods('/tmp/' + filename, @person_members)
        send_file('/tmp/' + filename, filename: filename, type: 'application/octet-stream')
      end
    end
  end

  def members
    @year = params[:year]

    if @year.nil?
      @year = Time.now.year
      Rails.logger.debug('Year is nil!')
    end

    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize_action_for @regional_organization

    @lvSum = 0
    @orchSum = 0
    @orchFullSum = 0
    @personSum = 0
    @orchestras = Orchestra.includes(%i[member report_sheets]).where('members.regional_organization_id =?',
                                                                     params[:regional_organization_id]).order('members.mglnr')
    @person_members = PersonMember.includes(:member, :tariff).where('members.regional_organization_id = ?',
                                                                    params[:regional_organization_id]).order('members.mglnr')

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
                              type: 'application/pdf',
                              disposition: 'inline'
      end
      format.csv
    end
  end

  def fee_shares
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    authorize_action_for @regional_organization

    @lvSum = 0
    @orchSum = 0
    @orchFullSum = 0
    @personSum = 0
    @orchestras = Orchestra.includes(%i[member report_sheets]).where('members.regional_organization_id =?',
                                                                     params[:regional_organization_id]).order('members.mglnr')
    @person_members = PersonMember.includes(:member, :tariff).where('members.regional_organization_id = ?',
                                                                    params[:regional_organization_id]).order('members.mglnr')

    respond_to do |format|
      format.pdf do
        pdf = RegionalOrganizationFeeSharePdf.new(@regional_organization, @orchestras, @person_members, view_context)
        send_data pdf.render, filename: "beitragsanteile_lv_#{@regional_organization.id}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
  end

  def oddset_report
    @regional_organzation = RegionalOrganization.find(params[:regional_organization_id])
    @report_sheets = ReportSheet.find_by_sql([
                                               'SELECT rs.* FROM report_sheets rs, members m WHERE rs.orchestra_id=m.id AND m.regional_organization_id = ? AND year = ?', params[:regional_organization_id], params[:year]
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
    authorize_action_for @regional_organization
    @year = params[:year]

    @year = Time.now.year if @year.nil?

    @before = if params[:before].nil?
                Time.new
              else
                Date.strptime(params[:before], '%d.%m.%Y')
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

  def renderOrchOds(tmpname, orchestras)
    RODF::Spreadsheet.file(tmpname) do
      table 'Orchester' do |t|
        t.row do
          cell 'Mglnr'
          cell 'Orchester-Name'
          cell 'Name'
          cell 'Strasse'
          cell 'PLZ'
          cell 'Ort'
          cell 'Email'
          cell 'Meldebogen-Jahr'
          cell I18n.t('report_sheet.children')
          cell I18n.t('report_sheet.teens')
          cell I18n.t('report_sheet.youth')
          cell I18n.t('report_sheet.adult')
          cell I18n.t('report_sheet.senior')
          cell I18n.t('report_sheet.gema')
          cell I18n.t('report_sheet.azubi')
          cell I18n.t('report_sheet.azubi_child')
          cell I18n.t('report_sheet.azubi_teens')
          cell I18n.t('report_sheet.azubi_youth')
          cell I18n.t('report_sheet.azubi_adult')
          cell I18n.t('report_sheet.azubi_senior')
          cell I18n.t('report_sheet.passive')
          cell I18n.t('report_sheet.supporters')
          cell I18n.t('report_sheet.child_ens')
          cell I18n.t('report_sheet.youth_ens')
          cell I18n.t('report_sheet.adult_ens')
          cell I18n.t('report_sheet.senior_ens')
          cell I18n.t('report_sheet.chamber_ens')
          cell I18n.t('report_sheet.other_ens')
          cell I18n.t('report_sheet.zo')
          cell I18n.t('report_sheet.zi_o')
          cell I18n.t('report_sheet.go')
          cell I18n.t('report_sheet.oz')
        end
        orchestras.each do |o|
          last_report = o.lastReportSheet

          t.row do
            cell o.member.mglnr
            cell o.cleanOrchName
            cell o.fullname
            cell o.member.strasse
            cell o.member.plz
            cell o.member.ort
            cell o.member.email
            unless last_report.nil?
              cell last_report.year
              cell last_report.children
              cell last_report.teens
              cell last_report.youth
              cell last_report.adult
              cell last_report.senior
              cell last_report.gema
              cell last_report.azubi
              cell last_report.azubi_child
              cell last_report.azubi_teens
              cell last_report.azubi_youth
              cell last_report.azubi_adult
              cell last_report.azubi_senior
              cell last_report.passive
              cell last_report.supporters
              cell last_report.child_ens
              cell last_report.youth_ens
              cell last_report.adult_ens
              cell last_report.senior_ens
              cell last_report.chamber_ens
              cell last_report.other_ens
              cell last_report.zo
              cell last_report.zi_o
              cell last_report.go
              cell last_report.oz
            end
          end
        end
      end
    end
  end

  def render_person_members_ods(tmpfile, person_members)
    RODF::Spreadsheet.file(tmpfile) do
      table 'Einzelmitglieder' do |t|
        t.row do
          cell 'Mglnr'
          cell 'Anrede'
          cell 'Vorname'
          cell 'Name'
          cell 'Strasse'
          cell 'PLZ'
          cell 'Ort'
          cell 'Email'
        end

        person_members.each do |pm|
          t.row do
            cell pm.member.mglnr
            cell pm.member.anrede
            cell pm.member.vorname
            cell pm.member.name
            cell pm.member.strasse
            cell pm.member.plz
            cell pm.member.ort
            cell pm.member.email
          end
        end
      end
    end
  end
end
