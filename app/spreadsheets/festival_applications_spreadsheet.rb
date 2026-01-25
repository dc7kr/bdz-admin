 class FestivalApplicationsSpreadsheet
  attr_accessor :festival_applications, :sheet

  def initialize(festival_applications)
    self.festival_applications = festival_applications
  end
  
  def render
    self.sheet = RODF::Spreadsheet.new
    t = self.sheet.table "Festival Anmeldungen"
    t.row do
      cell I18n.t("common.number")
      cell I18n.t("festival_application.group_type")
      cell I18n.t("festival_application.orch_name")
      cell I18n.t("festival_application.country_id")
      cell I18n.t("festival_application.num_players")
      cell I18n.t("contact_person.salutation")
      cell I18n.t("contact_person.first_name")
      cell I18n.t("contact_person.last_name")
      cell I18n.t("contact_person.street")
      cell I18n.t("contact_person.zip")
      cell I18n.t("contact_person.city")
      cell I18n.t("contact_person.country_code")
      cell I18n.t("contact_person.email")
      cell I18n.t("festival_application.special_cast")
      cell I18n.t("festival_application.equipment")
      cell I18n.t("festival_piece.composer")
      cell I18n.t("festival_piece.title")
      cell I18n.t("festival_piece.duration")
      cell I18n.t("festival_piece.composer")
      cell I18n.t("festival_piece.title")
      cell I18n.t("festival_piece.duration")
      cell I18n.t("festival_piece.composer")
      cell I18n.t("festival_piece.title")
      cell I18n.t("festival_piece.duration")
      cell I18n.t("festival_piece.composer")
      cell I18n.t("festival_piece.title")
      cell I18n.t("festival_piece.duration")
      cell I18n.t("festival_piece.composer")
      cell I18n.t("festival_piece.title")
      cell I18n.t("festival_piece.duration")
    end

    self.festival_applications.each do |app|
      grp_locale = if app.country_code == ISO3166::Country["DE"].alpha2
                    :de
      else
                    :en
      end

      t.row do
        cell app.id
        cell I18n.t("festival_application.group_types.#{app.group_type}")
        cell app.orch_name
        cell app.t_country
        cell app.num_players
        cell I18n.t("common.salutations.#{app.contact_person.salutation}", locale: grp_locale)
        cell app.contact_person.first_name
        cell app.contact_person.last_name
        cell app.contact_person.street
        cell app.contact_person.zip
        cell app.contact_person.city
        cell app.contact_person.t_country
        cell app.contact_person.email

        cell app.special_cast
        cell app.equipment

        app.festival_pieces.each do |p|
          cell p.composer
          cell p.title
          cell p.duration
        end
      end
    end
  end

   def bytes
    self.sheet.bytes
  end
end