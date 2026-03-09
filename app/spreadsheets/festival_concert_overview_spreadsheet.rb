class FestivalConcertOverviewSpreadsheet
  attr_accessor :festival_applications, :sheet

  def initialize(festival_applications)
    self.festival_applications = festival_applications
  end

  def render(view)
    self.sheet = RODF::Spreadsheet.new
    t = sheet.table "Konzertprogramm"

    sheet.style 'date-style-datetime', family: :cell do |s|
      s.property :number, 'number:date-format' => "DD.MM.YYYY HH:MM"
    end
    
    t.row do
      cell "Konzert"
      cell "ID"
      cell "Interpret"
      cell "Spieler"
      cell "Titel"
      cell "Dauer"
      cell "Komponist"
      cell "Bearbeiter"
      cell "Verlag"
      cell "Uraufführung"
      cell "Solist"
      cell "Vorname"
      cell "Name"
      cell "Email"
      cell "Telefon"
      cell "Link"
      cell "Werk letzte Änderung"
      cell "Teilnehmer letzte Änderung"
    end

    festival_applications.each do |fa|
      fa.festival_pieces.each do |fp|
        if fa.festival_concert.nil?
          concert_nr = "keine"
        else
          concert_nr = fa.festival_concert.number
        end

        t.row do 
          cell  concert_nr
          cell fa.id
          cell fa.orch_name
          cell fa.num_players
          cell fp.title
          cell fp.printable_duration
          cell fp.composer
          cell fp.arranger
          cell fp.publisher 
          cell fp.premiere
          cell fp.soloist
          cell fa.contact_person.first_name
          cell fa.contact_person.last_name
          cell fa.contact_person.email
          cell fa.contact_person.phone
          cell view.ef_festival_application_url(fa)
          cell fp.updated_at.to_datetime, style: 'date-style-datetime'
          cell fa.updated_at.to_datetime, style: 'date-style-datetime'
        end
      end
    end
  end

  def bytes
    self.sheet.bytes
  end
end
