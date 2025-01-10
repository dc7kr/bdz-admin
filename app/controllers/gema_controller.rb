require 'roo'

class GemaController < AuthenticatedNonResourceController
  def abgleich
    xlsx = Roo::Spreadsheet.open('./gema_test.xlsx')

    sh = xlsx.sheet(xlsx.sheets.first)
    p sh.row(1)
    p sh.row(2)

    p sh.row(3)
    p sh.last_row
    rownr = 3
    while rownr < sh.last_row
      row = sh.row(rownr)
      name = row[1]
      mglnr = row[12]
      mglnr = mglnr.gsub(/^.* - /, '')
      mglnr = mglnr.gsub('Bund Deutscher Zupfmusiker', '')
      print '<' + mglnr.to_s + '> - <' + name.to_s + ">\n"
      rownr += 1
    end
  end
end
