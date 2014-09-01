require 'odf/spreadsheet'

class RegionalOrganizationReportsController < AuthenticatedNonResourceController
  include OrchestrasHelper
  def index
    authorize! :member, :edit

    current_year = Time.now.year
    lv = RegionalOrganization.find(params[:regional_organization_id])
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
          rs = o.lastReportSheet
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
end
