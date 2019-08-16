class OrchestraMembersSpreadsheet

  attr_accessor :orchestra_members
  attr_accessor :sheet

  def initialize(orchestra_members)
    self.orchestra_members = orchestra_members
  end

  def render
    self.sheet = RODF::Spreadsheet.new

    t = self.sheet.table "Mitglieder" 

    t.row {
      cell "Vorname"
      cell "Name"
      cell "Mgl.Nr. des Vereins (*)"
      cell "Geburtsjahr"
      cell "Instrument"
      cell "(*) Nur für Landesorchester ausfüllen!"
    }

    orchestra_members.each do |om|
      t.row {
        cell om.first_name
        cell om.last_name
        cell om.mglnr
        cell om.date_of_birth
        cell om.instrument
      }
    end
  end

  def gen_file
    tmpfile = Tempfile.new("mgl")
    filename = tmpfile.path

    self.sheet.write_to filename

    filename
  end
end
