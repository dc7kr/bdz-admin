class GemaSpreadsheet

  attr_accessor :orchestras
  attr_accessor :sheet

  def initialize(orchestras)
    self.orchestras = orchestras
  end

  def render
	    self.sheet = RODF::Spreadsheet.new
      t = self.sheet.table "GEMA Zahlen" 
      t.row {
        cell I18n.t("member.mglnr")
        cell I18n.t("orchestra.orchName")
        cell "Adresse"
        cell "Mitglieder"
      }

      orchestras.each do |o|
        t.row {
          cell o.member.mglnr
          cell o.orchName
          cell o.inlineFullAddress
          cell o.gema
          }
      end
  end
end
