class ParticipantSheetPdf < Prawn::Document
  def initialize(appl, view)
    super(top_margin: 70, left_margin: 70)
    @appl = appl
    @invoice = appl.invoice

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
      text 'Unknown arrival time.'
    else
      text "#{I18n.t('event_meal.arrival_time')} #{@view.l app.event_meal.arrival_time}"
    end

    move_down 20
    text "#{I18n.t('contact_person.phone')}:", size: 14, style: :bold

    return unless app.payment_status != 'S'

    if @invoice.sum.negative?
      save_stroke_and_fill
      fill_color '00ff00'
      fill_and_stroke_rounded_rectangle([400, 700], 100, 25, 5)
      stroke_color '000000'
      fill_color '000000'
      draw_text @view.format_currency(@invoice.sum, 'EUR'), at: [420, 685]
      restore_stroke_and_fill
    elsif @invoice.sum.positive?
      save_stroke_and_fill
      fill_color 'ff0000'
      stroke_color 'ff0000'
      fill_and_stroke_rounded_rectangle([400, 700], 100, 25, 5)
      stroke_color 'ffffff'
      fill_color 'ffffff'
      draw_text @view.format_currency(@invoice.sum, 'EUR'), at: [420, 685]
      restore_stroke_and_fill
    end
  end

  def invoice(appl)
    move_down 20
    text I18n.t('participant_sheet.tickets'), style: :bold, size: 14
    rows = []
    count = 0

    @invoice.items.each do |i|
      count += i.count if i.price.positive?

      if appl.payment_status == 'S'
        rows << [i.count, i.label, '', ''] if i.price.positive?
      else
        rows << [i.count, i.label, @view.format_currency(i.price, 'EUR'),
                 @view.format_currency(i.count * i.price, 'EUR')]
      end
    end

    rows << if appl.payment_status == 'S'
              [count, I18n.t('common.sum'), '', '']
            else
              [count, I18n.t('common.sum'), '', @view.format_currency(@invoice.sum, 'EUR')]
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

    move_down 20
    return unless !@appl.soloist_tickets.nil? && @appl.soloist_tickets.positive?

    text "#{@appl.soloist_tickets} #{I18n.t('festival_application.soloist_tickets')}"
  end

  def performance(app)
    move_down 20
    text I18n.t('participant_sheet.performance'), style: :bold

    text "#{I18n.t('festival_application.num_players')}: #{app.num_players}"
    concert = app.festival_concert

    if concert.nil?
      text "#{I18n.t('festival_application.festival_concert_id')}: N/A"
    else
      text "#{I18n.t('festival_application.festival_concert_id')}: #{app.festival_concert.title} #{@view.l app.festival_concert.event_time}"
    end

    text "#{I18n.t('festival_application.rehearsal_time')}: #{app.rehearsal_time.localtime.strftime('%H:%M')}" unless app.rehearsal_time.nil?
    text "#{I18n.t('festival_application.stage_time')}: #{app.stage_time.strftime('%H:%M')}" unless app.stage_time.nil?
    text "#{I18n.t('festival_application.equipment')}: #{app.equipment}"
    text "#{I18n.t('festival_application.comment')}: #{app.comment}"
  end

  def food(app)
    move_down 20
    if app.event_meal.nil?
      save_stroke_and_fill
      fill_color 'ff0000'
      text 'KEINE ESSENSMELDUNG!', style: :bold, size: 20
      restore_stroke_and_fill
    else
      text I18n.t('participant_sheet.food'), style: :bold
      text "#{I18n.t('participant_sheet.meals')} #{app.event_meal.tln}"
      text "#{I18n.t('event_meal.veg')} #{app.event_meal.veg}"
    end
  end

  def line_cond(label, value)
    return if value.nil? || value.zero?

    text "#{I18n.t(label)} #{value}"
  end

  def body(app)
    invoice(app)
    food(app)
    performance(app)
  end
end
