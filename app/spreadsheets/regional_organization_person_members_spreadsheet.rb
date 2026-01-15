class RegionalOrganizationPersonMembersSpreadsheet < RegionalOrganizationReportSpreadsheet

  attr_accessor :person_members 

  def initialize(regional_organization, person_members)
    super(regional_organization)
    self.person_members = person_members
  end

  def render
    self.sheet = RODF::Spreadsheet.new

    sheet.table "Einzelmitglieder" do |t|
      t.row do
        cell "Mglnr"
        cell "Anrede"
        cell "Vorname"
        cell "Name"
        cell "Strasse"
        cell "PLZ"
        cell "Ort"
        cell "Email"
      end

      person_members.each do |pm|
        t.row do
          cell pm.member.mglnr
          cell pm.member.anrede
          cell pm.member.vorname
          cell pm.member.name
          cell pm.member.strasse
          cell pm.member.plz
          cell pm.member.ort
          cell pm.member.email
        end
      end
    end
  end
end

