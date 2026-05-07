class ParticipantSheetPdf < Prawn::Document
  def initialize(appl, view)
    super(top_margin: 50, left_margin: 70)
    @appl = appl
    @invoice_hash = appl.get_ticket_invoice.to_hash[:invoice]

    @view = view
    head(@appl)
    body(@appl)
  end

  def save_stroke_and_fill
    @old_fill = fill_color
    @old_stroke = stroke_color
  end

  def restore_stroke_and_fill
    fill_color @old_fill
    stroke_color @old_stroke
  end

  def head(app)
    text "#{I18n.t('event_meal.participant_id')} #{app.id}", size: 20, style: :bold
    text "#{app.orch_name} (#{I18n.t("festival_application.group_types.#{app.group_type}")})", size: 20, style: :bold

    if app.event_meal.nil? || app.event_meal.arrival_time.nil?
      text "Unknown arrival time."
    else
      text "#{I18n.t('event_meal.arrival_time')} #{@view.l app.event_meal.arrival_time}"
    end

    move_down 10
    text "#{app.contact_person.fullname}", size: 14, style: :bold
    text "#{I18n.t('contact_person.phone')}: #{app.contact_person.phone}", size: 14, style: :bold

    return if app.payment_status == "S"

    save_stroke_and_fill

    rect_fill = nil

    if app.payment_status == "F"
      rect_fill = "ffffff"
      rect_stroke = "000000"
      text_color = "000000"
    else
      rect_fill = "ff0000"
      rect_stroke = "ff0000"
      text_color = "ffffff"
    end
    fill_color rect_fill
    stroke_color rect_stroke
    fill_and_stroke_rounded_rectangle([ 400, 725 ], 100, 25, 5)
    stroke_color text_color
    fill_color text_color
    draw_text @view.format_currency(@invoice_hash[:sum][:grand_total], "EUR"), at: [ 420, 710 ]

    restore_stroke_and_fill


  end

  def invoice(appl)
    rows = []
    count = 0

    rows << [ appl.tickets, I18n.t("festival_application.tickets")]
    rows << [ appl.tickets_red, I18n.t("festival_application.tickets_red")]

    move_down 10
    text I18n.t("participant_sheet.tickets"), style: :bold, size: 14

    if @appl.soloist_tickets.present? && @appl.soloist_tickets.positive?
      rows << [ @appl.soloist_tickets, I18n.t('festival_application.soloist_tickets') ]
    end

    table rows do
      cells.borders = []
      cells.style(padding: 2)
      columns(0).align = :right
      columns(0).font_style = :bold
      columns(1).align = :left
      columns(2).align = :right
      columns(3).align = :right
    end

    move_down 10
  end

  def performance(app)
    move_down 20
    text I18n.t("participant_sheet.performance"), style: :bold, size: 14

    concert = app.festival_concert

    rows = []
    rows << [ I18n.t('festival_application.num_players'), "#{app.num_players}" ]

    if concert.nil?
      text "#{I18n.t('festival_application.festival_concert_id')}: N/A"
    else
      rows << [ I18n.t('festival_application.festival_concert_id'), "#{app.festival_concert.full_title} #{@view.l app.festival_concert.event_time}" ]
      rows << [ I18n.t('festival_concert.location'), app.festival_concert.location ]
      rows << [ I18n.t('festival_application.rehearsal_time'), "#{@view.l app.rehearsal_time,format: "%H:%M Uhr"}" ] unless app.rehearsal_time.nil?
      rows << [ I18n.t('festival_application.stage_time'), "#{@view.l app.stage_time.to_time, format: "%H:%M Uhr"}" ] unless app.stage_time.nil?
      rows << [I18n.t('festival_application.equipment'), "#{app.equipment}" ]
      rows << [I18n.t('festival_application.comment'), "#{app.comment}" ]

      table rows do
        cells.borders = []
        cells.style(padding: 2)
        columns(0).font_style = :bold
        columns(0).align = :right
        columns(1).align = :left
      end
    end

  end

  def food(app)
    move_down 20
    if app.event_meal.nil?
      save_stroke_and_fill
      fill_color "ff0000"
      text "KEINE ESSENSMELDUNG!", style: :bold, size: 20
      restore_stroke_and_fill
    else
      text I18n.t("participant_sheet.food"), style: :bold, size: 14

      meal = app.event_meal

      rows = []
      rows << [ meal.veg, I18n.t('event_meals.veg') ]
      rows << [ meal.tln-meal.veg, I18n.t('event_meals.regular_meals') ]
      rows << [ meal.tln, I18n.t('participant_sheet.meals') ]

      table rows do
        cells.borders = []
        cells.style(padding: 2)
        columns(0).font_style = :bold
        columns(0).align = :right
        columns(1).align = :left
      end

      move_down 20

      text I18n.t("event_meals.meal_times"), style: :bold, size: 14

      rows = []
      rows << [ "", I18n.t("event_meals.lunch"), I18n.t("event_meals.dinner") ]
      rows << [ I18n.t('date.day_names')[4], I18n.t("event_meals.l_do")[meal.lunch1-1], I18n.t("event_meals.d_do")[meal.dinner1-1] ]
      rows << [ I18n.t('date.day_names')[5], I18n.t("event_meals.l_fr")[meal.lunch2-1], I18n.t("event_meals.d_fr")[meal.dinner2-1] ]
      rows << [ I18n.t('date.day_names')[6], I18n.t("event_meals.l_sa")[meal.lunch3-1], I18n.t("event_meals.d_sa")[meal.dinner3-1] ]

      table rows do
        cells.borders = []
        cells.style(padding: 2)

        rows(0).font_style = :bold
        columns(0).font_style = :bold
        columns(0).align = :right
        columns(1).align = :left
        columns(2).align = :left
      end
    end
  end

  def line_cond(label, value)
    return if value.nil? || value.zero?

    text "#{I18n.t(label)} #{value}"
  end

  def signature(app)
    move_down 30
    text I18n.t("festival_applications.confirm_ticket_received"), style: :bold
    move_down 30
        font_size 12
        text("_______________________________________")
        font_size 12
        text(app.contact_person.fullname)

  end

  def body(app)
    invoice(app)
    food(app)
    performance(app)
    signature(app)
  end
end
