class RegionalOrganizationOrchestrasSpreadsheet < RegionalOrganizationReportSpreadsheet

  attr_accessor :orchestras, :year

  def initialize(regional_organization, orchestras)
    super(regional_organization)
    self.orchestras = orchestras
  end


  def render
    self.sheet = RODF::Spreadsheet.new

    sheet.table "Orchester" do |t|
      t.row do
        cell "Mglnr"
        cell "Orchester-Name"
        cell "Name"
        cell "Strasse"
        cell "PLZ"
        cell "Ort"
        cell "Email"
        cell "Meldebogen-Jahr"
        cell I18n.t("report_sheet.children")
        cell I18n.t("report_sheet.teens")
        cell I18n.t("report_sheet.youth")
        cell I18n.t("report_sheet.adult")
        cell I18n.t("report_sheet.senior")
        cell I18n.t("report_sheet.gema")
        cell I18n.t("report_sheet.azubi")
        cell I18n.t("report_sheet.azubi_child")
        cell I18n.t("report_sheet.azubi_teens")
        cell I18n.t("report_sheet.azubi_youth")
        cell I18n.t("report_sheet.azubi_adult")
        cell I18n.t("report_sheet.azubi_senior")
        cell I18n.t("report_sheet.passive")
        cell I18n.t("report_sheet.supporters")
        cell I18n.t("report_sheet.child_ens")
        cell I18n.t("report_sheet.youth_ens")
        cell I18n.t("report_sheet.adult_ens")
        cell I18n.t("report_sheet.senior_ens")
        cell I18n.t("report_sheet.chamber_ens")
        cell I18n.t("report_sheet.other_ens")
        cell I18n.t("report_sheet.zo")
        cell I18n.t("report_sheet.zi_o")
        cell I18n.t("report_sheet.go")
        cell I18n.t("report_sheet.oz")
      end
      self.orchestras.each do |o|
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

def render_two
    self.sheet = RODF::Spreadsheet.new

    sheet.table "Orchester" do |t|
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
        o.lastReportSheet

        t.row do
          cell o.member.mglnr
          cell o.orchName
          cell o.member.email
          cell oc["V"].to_s
          cell oc["S"].to_s
          cell oc["G"].to_s
          cell oc["D"].to_s
          cell oc["J"].to_s
          cell oc["O"].to_s
        end
      end
    end
    sheet.table "Orchester-Statistik" do |t|
      t.row do
        cell "Mglnr"
        cell I18n.t("report_sheet.total_active")
        cell I18n.t("report_sheet.passive")
        cell I18n.t("report_sheet.child_ens")
        cell I18n.t("report_sheet.youth_ens")
        cell I18n.t("report_sheet.adult_ens")
        cell I18n.t("report_sheet.senior_ens")
        cell I18n.t("report_sheet.chamber_ens")
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

end
