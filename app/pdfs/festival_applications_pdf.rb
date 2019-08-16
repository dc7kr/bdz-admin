class FestivalApplicationsPdf < Prawn::Document

  include CountryHelper

  def initialize(applications, view)
    super(top_margin: 70)
    @applications = applications

    @view = view
	@applications.each do |app|
    	head(app)
		address(app.contact_person)
		pieces(app)
	end
  end
  
  def head(app)
    text "#{I18n.t('festival_application',:count=>1)} Nr. #{app.id}", size: 20, style: :bold
    text "#{app.orch_name} (#{I18n.t('festival_application.group_types.'+app.group_type)})", size: 20, style: :bold
	text "Herkunftsland: "+app.t_country, size:16
	text "Dirigent: "+app.conductor
    if (not app.event_meal.nil?) then
      text "Ankunftszeit: "+I18n.l(app.event_meal.arrival_time)
    end
  end

  def address(contact)
    move_down 20
	text "Kontaktperson", style: :bold
	if contact == nil then
		return
	end
	text I18n.t('common.salutations.'+contact.salutation)+" "+ contact.first_name+" "+contact.last_name
	text contact.street
	text contact.zip+" "+contact.city
	text contact.phone
	text contact.email

  end
  
  def pieces(app)
    move_down 20
	text I18n.t('festival_piece',:count=>3), style: :bold
	
	if  app.festival_pieces.count > 0 then 
    	table piece_rows(app) do
      	row(0).font_style = :bold
      	columns(1..3).align = :right
      	self.row_colors = ["DDDDDD", "FFFFFF"]
      	self.header = true
    end
	else 
		text "keine", style: :bold
	end
	move_down 30
  end

  def piece_rows(app)
    [[I18n.t('festival_piece.composer'), I18n.t('festival_piece.title'),I18n.t('festival_piece.duration') ]] +
	
	app.festival_pieces.map do |p| 
	    [p.composer,p.title,p.duration] 
    end
  end

end

