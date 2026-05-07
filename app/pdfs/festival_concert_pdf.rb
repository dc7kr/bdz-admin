class FestivalConcertPdf < Prawn::Document
  attr_accessor :concert, :view
  include CountryHelper

  def initialize(concert, view)
    super(top_margin: 70)
    self.concert = concert
    self.view = view

    self.font_families.update("OpenSans" => {
                                normal: Rails.root.join("vendor/assets/fonts/Open_Sans/OpenSans-Regular.ttf"),
                                italic: Rails.root.join("vendor/assets/fonts/Open_Sans/OpenSans-Italic.ttf"),
                                bold: Rails.root.join("vendor/assets/fonts/Open_Sans/OpenSans-Bold.ttf"),
                                bold_italic: Rails.root.join("vendor/assets/fonts/Open_Sans/OpenSans-BoldItalic.ttf")
    })

    font "OpenSans"

  end
  def generate
    head(self.concert)
    stroke_horizontal_rule
    self.concert.festival_applications.order(:program_item).each do |fa|
      next unless fa.permission 
      programme(fa)
      stroke_horizontal_rule
    end
    if self.concert.outdoor == true
      self.concert.outdoor_participants.order(:program_item).each do |fa|
        next unless fa.permission 
        programme(fa)
        stroke_horizontal_rule
      end
    end
  end

  def head(concert)
    text concert.location
    text I18n.l concert.event_time
    text "#{I18n.t('festival_concert', count: 1)} Nr. #{concert.number}", size: 20, style: :bold
    text concert.full_title, size: 20, style: :bold
    text concert.subtitle
  end

  def programme(app)

    return unless app.permission
    move_down 5
    text app.orch_name, style: :bold
    label = nil
    if app.group_type == "O"
      label = "#{I18n.t("festival_application.conductor")}: "
    else
      label = ""
    end

    text "#{label}#{app.conductor}" if app.conductor.present?
    move_down 2


    app.festival_pieces.each do |piece|
      piece_row(piece)
    end

  end

  def piece_row(piece)
    text piece.composer
    text piece.title, style: :bold
    text "#{I18n.t("festival_piece.duration")}: #{I18n.l piece.duration, format: "%H:%M"}"
    move_down 2
  end
end
