require 'odf/spreadsheet'

module MagazineReportHelper


  def renderSamplingListOds(filename,samplings)
    ODF::Spreadsheet.file(filename) do
      table "Samplings"  do |t|
        t.row {
          cell "Lfd Nr"
          cell I18n.t("contact.company")
          cell I18n.t("contact.department")
          cell I18n.t("contact.fullname")
          cell I18n.t("contact.street")
          cell I18n.t("contact.city")
          cell I18n.t("country.s")
          cell "Zeitungen"
        }
        rownr=1
        samplings.each do |s|
          row {
            cell rownr
            cell s.company
            cell s.department
            cell s.fullname
            cell s.street
            cell s.zip+" "+s.city
            cell s.t_country
            cell s.count , :type=> :float
          }
          rownr+=1
        end
      end
    end
  end
  
  def renderOrchestraMagazineListOds(filename,orchestras)

    ODF::Spreadsheet.file(filename) do

      table "Orchester" do
        row {
          cell    "Lfd Nr"
          cell I18n.t("member.mglnr")
          cell I18n.t("orchestra.orch_name")
          cell "Orchester2"
          cell I18n.t("member.fullname")
          cell I18n.t("member.street")
          cell I18n.t("common.country_code")
          cell I18n.t("contact.zip")
          cell I18n.t("contact.city")
          cell I18n.t("country.s")
          cell "Zeitungen"
        }

     	  nr=1
        orchestras.sort_by { |item| [item[:magazines],item[:mglnr]]}.each do |data|
          row {
            cell nr
            cell data[:mglnr]
            cell data[:name]
            cell data[:name2]
            cell data[:fullname]
            cell data[:strasse]
			      cell data[:t_country]
            cell data[:plz]
            cell data[:ort]
            cell data[:land]
            cell data[:magazines]
          }
		      nr+=1
        end
      end
	  end
  end
end
