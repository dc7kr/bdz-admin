class GemaSpreadsheet
  attr_accessor :orchestras, :sheet

  def initialize(orchestras)
    self.orchestras = orchestras
  end

  def render
    self.sheet = RODF::Spreadsheet.new
    t = sheet.table 'GEMA Zahlen'
    t.row do
      cell I18n.t('member.mglnr')
      cell I18n.t('orchestra.orchName')
      cell 'Adresse'
      cell 'Mitglieder'
    end

    orchestras.each do |o|
      t.row do
        cell o.member.mglnr
        cell o.orchName
        cell o.inlineFullAddress
        cell o.gema
      end
    end
  end
end
