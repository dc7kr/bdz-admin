class OrchestraMembersSpreadsheet
  attr_accessor :orchestra_members, :sheet

  def initialize(orchestra_members)
    self.orchestra_members = orchestra_members
  end

  def render
    self.sheet = RODF::Spreadsheet.new

    t = sheet.table "Mitglieder"

    t.row do
      cell "Vorname"
      cell "Name"
      cell "Mgl.Nr. des Vereins (*)"
      cell "Geburtsjahr"
      cell "Instrument"
      cell "(*) Nur für Landesorchester ausfüllen!"
    end

    orchestra_members.each do |om|
      t.row do
        cell om.first_name
        cell om.last_name
        cell om.mglnr
        cell om.date_of_birth
        cell om.instrument
      end
    end
  end

  def gen_file
    tmpfile = Tempfile.new("mgl")
    filename = tmpfile.path

    sheet.write_to filename

    filename
  end
end
