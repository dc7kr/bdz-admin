class CompanyPaperDocument < Prawn::Document
  include CountryHelper

  def initialize
    super
    @left_margin = 25
    @addr_start = 123
    @addr_xpos = 30
    @addr_rowskip = 12
    @heading_pos = [20, 500]
    @datepos = [390, @heading_pos[1] + 24]
    # font "Helvetica", :size => 10

    font_families.update(
      'MyFont' => {
        normal: BDZ_SETTINGS['fonts']['dir'] + '/' + BDZ_SETTINGS['fonts']['normal'],
        bold: BDZ_SETTINGS['fonts']['dir'] + '/' + BDZ_SETTINGS['fonts']['bold']
      }
    )
    font 'MyFont', size: 10
  end

  def print_headline(txt)
    text_box txt, at: @heading_pos, width: 300, style: :bold, size: 12
  end

  def print_date(city, date)
    datestr = city + ', ' + I18n.l(date, format: :date_only)
    text_box datestr, at: @datepos, width: 130
  end

  def print_address(addressee)
    rowpos = cursor - @addr_start
    xpos = @addr_xpos
    text_box addressee.company, at: [xpos, rowpos]
    rowpos -= @addr_rowskip
    text_box addressee.name, at: [xpos, rowpos]
    rowpos -= @addr_rowskip
    text_box addressee.street, at: [xpos, rowpos]
    rowpos -= @addr_rowskip
    text_box addressee.zip + ' ' + addressee.city, at: [xpos, rowpos]
    rowpos -= @addr_rowskip
    rowpos -= @addr_rowskip
    return unless addressee.country_code != 'DE'

    text_box translated_country(addressee.country_code, 'en'), at: [xpos, rowpos]
  end
end
