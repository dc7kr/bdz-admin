require "rodf"

module MagazineReportHelper
  def render_magazine_address_list(filename, de_rows, ext_rows)
    RODF::Spreadsheet.file(filename) do |sheet|
      sheet.table "Inland" do |t|
        MagazineReportHelper._add_heading(t)
        MagazineReportHelper._add_data(t, de_rows)
      end

      sheet.table "Ausland" do |t|
        MagazineReportHelper._add_heading(t)
        MagazineReportHelper._add_data(t, ext_rows)
      end
    end
  end

  ###########
  # Private
  ###########

  def self._add_heading(table)
    table.row do
      cell "Lfd Nr"
      cell I18n.t("common.identifier")
      cell I18n.t("contact.company")
      cell I18n.t("contact.department")
      cell I18n.t("contact.fullname")
      cell I18n.t("contact.street")
      cell I18n.t("contact.zip")
      cell I18n.t("contact.city")
      cell I18n.t("country.one")
      cell "Zeitungen"
    end
  end

  def self._add_data(table, rows)
    nr = 1

    rows.sort_by { |item| [ item[:zip], item[:magazines] ] }.each do |data|
      table.row do
        cell nr
        cell data[:identifier]
        cell data[:company]
        cell data[:department]
        cell data[:fullname]
        cell data[:street]
        cell data[:zip]
        cell data[:city]
        cell data[:country]
        cell data[:magazines]
      end
      nr += 1
    end
  end
end
