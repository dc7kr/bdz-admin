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
    self.concert.festival_applications.order(:program_item).each do |fa|
      programme(fa)
      stroke_horizontal_rule
    end
  end

  def head(concert)
    text "#{I18n.t('festival_concert', count: 1)} Nr. #{concert.number}", size: 20, style: :bold
    text concert.title, size: 20, style: :bold
  end

  def programme(app)
    move_down 20
    text app.orch_name, style: :bold
    text "#{I18n.t("festival_application.conductor")}: #{app.conductor}"
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
