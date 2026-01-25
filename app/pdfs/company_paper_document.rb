require 'prawn/measurement_extensions'
class CompanyPaperDocument < Prawn::Document
  include CountryHelper

  def initialize(view)
    super(left_margin: 25.mm, right_margin: 20.mm)
    @view = view
    @left_margin = 25.mm
    @from_start = 297.mm-51.mm
    @addr_start = 297.mm-61.mm
    @addr_xpos = 25.mm
    @addr_rowskip = 12

    @fold_one_y = 192.mm
    @fold_two_y = 148.5.mm
    @fold_three_y = 87.mm
    @heading_pos = [ 0, 500 ]
    @datepos = [ 390, @heading_pos[1] + 24 ]
    # font "Helvetica", :size => 10

    font_families.update(
      "Serif" => {
        normal: "#{BDZ_SETTINGS['fonts']['dir']}/#{BDZ_SETTINGS['fonts']['serif']['normal']}",
        bold: "#{BDZ_SETTINGS['fonts']['dir']}/#{BDZ_SETTINGS['fonts']['serif']['bold']}"
      }
    )
    font "Serif", size: 12
    
    font_families.update(
      "Sans" => {
        normal: "#{BDZ_SETTINGS['fonts']['dir']}/#{BDZ_SETTINGS['fonts']['sans']['normal']}",
        bold: "#{BDZ_SETTINGS['fonts']['dir']}/#{BDZ_SETTINGS['fonts']['sans']['bold']}"
      }
    )
    font "Serif", size: 12
  end

  def create_content(contact, addressee, headline, date: Time.now)
    print_headline headline

    print_body(contact)

    bounding_box([ 0, @addr_start], width: 80.mm) do 
      print_from_line contact
      print_address addressee
    end
    print_date contact["city"], date

    print_folding_marks
  end

  def print_folding_marks
    canvas do 
      line [0, @fold_one_y], [5.mm, @fold_one_y]
      stroke
      line [0, @fold_two_y], [10.mm, @fold_two_y]
      stroke
      line [0, @fold_three_y], [5.mm, @fold_three_y]
      stroke
    end
  end


  def print_headline(txt)
    text_box txt, at: @heading_pos, width: 300, style: :bold, size: 14
  end

  def print_date(city, date)
    datestr = "#{city}, #{I18n.l(date, format: :date_only)}"
    text_box datestr, at: @datepos, width: 150
  end

  def print_from_line(contact)
    ypos = 297-51
    bounding_box([ 0, ypos.mm ], width:80.mm) do 
      line = "#{contact["dept"]} - #{contact["name"]} - #{contact["street"]} - #{contact["zip"]} #{contact["city"]}"
      font("Sans", size: 6) do 
        text line
        transparent(0.5) { stroke_bounds }
      end
    end
  end


  def print_address(addressee)
    text addressee.company
    text addressee.name
    text addressee.street
    text "#{addressee.zip} #{addressee.city}"
    return unless addressee.country_code != "DE"

    text translated_country(addressee.country_code, "en")
  end

  def print_body
     # This must be populated by the child classes!
  end
end
