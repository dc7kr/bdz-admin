class ParticipantOverviewSpreadsheet
  attr_accessor :festival_applications, :sheet, :view

  def initialize(festival_applications, view)
    self.festival_applications = festival_applications
    self.view = view
  end

  def render
    self.sheet = RODF::Spreadsheet.new

    sheet.style 'bold-cell', family: :cell do |s|
      s.property :text, 'font-weight' => 'bold'
    end

    t = sheet.table "Festival-Teilnehmer"

    t.row do
      cell I18n.t("common.number"), style: 'bold-cell'
      cell I18n.t("festival_application.group_type"), style: 'bold-cell'
      cell I18n.t("festival_application.orch_name"), style: 'bold-cell'
      cell I18n.t("festival_application.conductor"), style: 'bold-cell'
      cell I18n.t("festival_application.country_code"), style: 'bold-cell'
      cell I18n.t("festival_application.num_players"), style: 'bold-cell'
      cell I18n.t("festival_concert", count:1), style: 'bold-cell'
      cell I18n.t("festival_concerts.concert_day"), style: 'bold-cell'
      cell I18n.t("contact_person.first_name"), style: 'bold-cell'
      cell I18n.t("contact_person.last_name"), style: 'bold-cell'
      cell I18n.t("contact_person.email"), style: 'bold-cell'
      cell I18n.t("contact_person.phone"), style: 'bold-cell'
      cell I18n.t("event_meal.arrival_time"), style: 'bold-cell'
      cell I18n.t("festival_application.tickets"), style: 'bold-cell'
      cell I18n.t("festival_application.tickets_red"), style: 'bold-cell'
      cell I18n.t("festival_application.soloist_tickets"), style: 'bold-cell'
      cell I18n.t("event_meal.lunch1"), style: 'bold-cell'
      cell I18n.t("event_meal.dinner1"), style: 'bold-cell'
      cell I18n.t("event_meal.lunch2"), style: 'bold-cell'
      cell I18n.t("event_meal.dinner2"), style: 'bold-cell'
      cell I18n.t("event_meal.lunch3"), style: 'bold-cell'
      cell I18n.t("event_meal.dinner3"), style: 'bold-cell'
      cell I18n.t("festival_applications.due_amount"), style: 'bold-cell'
    end

        
    self.festival_applications.each do |app|

      invoice_hash = app.get_ticket_invoice.to_hash[:invoice]

      if app.payment_status == "F" or app.payment_status == "S"
        due_amount = 0
      else
        due_amount = invoice_hash[:sum][:grand_total]
      end

      t.row do |r|
        r.cell app.id
        r.cell I18n.t("festival_application.group_types.#{app.group_type}")
        r.cell app.orch_name
        r.cell app.conductor
        r.cell app.country_code
        r.cell app.num_players
        r.cell app.festival_concert.full_title
        r.cell I18n.l app.festival_concert.event_time, format: "%a"
        r.cell app.contact_person.first_name
        r.cell app.contact_person.last_name
        r.cell app.contact_person.email
        r.cell app.contact_person.phone


        meal = app.event_meal
        if meal.nil? || meal.arrival_time.nil?
          r.cell "N/A"
        else
          r.cell I18n.l app.event_meal.arrival_time, format: "%d.%m.%Y %H:%M"
        end
        
        r.cell app.tickets
        r.cell app.tickets_red
        r.cell app.soloist_tickets

        if meal.present?
          r.cell meal.lunch1.to_i
          r.cell meal.dinner1.to_i
          r.cell meal.lunch2.to_i 
          r.cell meal.dinner2.to_i
          r.cell meal.lunch3.to_i
          r.cell meal.dinner3.to_i
        else
          r.cell ""
          r.cell ""
          r.cell ""
          r.cell ""
          r.cell ""
          r.cell ""
        end
        
        r.cell view.number_to_currency(due_amount, precision: 2, locale: :de)
      end
    end
  end

  def bytes
    self.sheet.bytes
  end
end
