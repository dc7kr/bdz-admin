require 'roo'

class GemaController < AuthenticatedNonResourceController
  def abgleich
    xlsx = Roo::Spreadsheet.open('./gema_test.xlsx')

    sh = xlsx.sheet(xlsx.sheets.first)
    Rails.logger.debug sh.row(1)
    Rails.logger.debug sh.row(2)

    Rails.logger.debug sh.row(3)
    Rails.logger.debug sh.last_row
    rownr = 3
    while rownr < sh.last_row
      row = sh.row(rownr)
      name = row[1]
      mglnr = row[12]
      mglnr = mglnr.gsub(/^.* - /, '')
      mglnr = mglnr.gsub('Bund Deutscher Zupfmusiker', '')
      Rails.logger.debug { "<#{mglnr}> - <#{name}>\n" }
      rownr += 1
    end
  end
end
