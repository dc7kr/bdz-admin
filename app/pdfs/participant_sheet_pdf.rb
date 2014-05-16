class ParticipantSheetPdf < Prawn::Document

  def initialize(appl, view)
    super(top_margin: 70)
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
    text "#{@view.t('event_meal.participant_id')} #{app.id}", size: 20, style: :bold
    text "#{app.orch_name} (#{@view.t('festival_application.group_types.'+app.group_type)})", size: 20, style: :bold
    if app.event_meal.nil? or app.event_meal.arrival_time.nil? then
      text "Unknown arrival time."
    else
      text "#{@view.t('event_meal.arrival_time')} #{@view.l app.event_meal.arrival_time}"
    end

    if (@invoice.sum < 0 ) then
      save_stroke_and_fill 
      fill_color "00ff00"
      fill_and_stroke_rounded_rectangle([400,700], 100,25,5)
      stroke_color "000000"
      fill_color "000000"
      draw_text @view.format_currency(@invoice.sum,"EUR"), :at => [ 420,685]
      restore_stroke_and_fill
    elsif  (@invoice.sum > 0 ) then
      save_stroke_and_fill 
      fill_color "ff0000"
      stroke_color "ff0000"
      fill_and_stroke_rounded_rectangle([400,700], 100,25,5)
      stroke_color "ffffff"
      fill_color "ffffff"
      draw_text @view.format_currency(@invoice.sum,"EUR"), :at => [ 420,685]
      restore_stroke_and_fill
    end
  end

  def invoice(appl)
    move_down 20
    text @view.t('participant_sheet.tickets') , style: :bold,:size=>14
	  rows = Array.new

    @invoice.items.each do |i|
      rows << [ i.count, i.label, @view.format_currency(i.price,'€'), @view.format_currency(i.count*i.price,'€')]
    end
    rows << [ "", @view.t("common.sum"),"",@view.format_currency(@invoice.sum,'€') ]

    table rows do
      cells.borders=[]
      cells.style(:padding=>2)
      columns(0).align = :right
	    columns(0).font_style = :bold
      columns(1).align = :left
      columns(2).align = :right
      columns(3).align = :right
    end
  end

  def performance(app)
    move_down 20
    text @view.t('participant_sheet.performance') , style: :bold

    text "#{@view.t('festival_application.num_players')} #{app.num_players}" 
    text "#{@view.t('festival_application.festival_concert_id')} #{app.festival_concert.title} #{@view.l app.festival_concert.event_time}" 
    if not app.rehearsal_time.nil? 
      text "#{@view.t('festival_application.rehearsal_time')} #{@view.l app.rehearsal_time}" 
    end
  end
  def food(app)
    move_down 20
    if app.event_meal.nil? then
      save_stroke_and_fill
      fill_color "ff0000"
      text "KEINE ESSENSMELDUNG!", style: :bold, size: 20
      restore_stroke_and_fill
    else 
      text @view.t('participant_sheet.food') , style: :bold
      text "#{@view.t('participant_sheet.meals')} #{app.event_meal.tln}" 
      text "#{@view.t('event_meal.veg')} #{app.event_meal.veg}" 
    end
  end

 
  def line_cond(label,value) 
    if value.nil? or value ==0 
      return
    end
    text "#{@view.t(label)} #{value}"
  end

  def body(app)

    invoice(app)
    food(app)
    performance(app)
  end


end
