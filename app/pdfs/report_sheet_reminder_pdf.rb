class ReportSheetReminderPdf < CompanyPaperDocument
  attr_accessor :orchestra

  def initialize(view, orchestra)
    super(view)
    self.orchestra = orchestra
    today = Time.now
    @year = today.year

    @margin_left = 25
  end

  def print_body(from)
    bounding_box([0, 167.mm], width: 150.mm) do 
      par_distance = 10
      text "Sehr geehrte Damen und Herren,"
      move_down par_distance 
      text "ich möchte Sie an die Abgabe Ihrer Meldebögen bis zum 31. Januar #{@year} erinnern."
      move_down par_distance 

      text "Falls noch nicht geschehen, reichen Sie bitte Ihre Mitgliedermeldung fristgerecht ein."
      move_down par_distance 

      text "Für verspätet eingereichte Meldebögen (d.h. nach dem 31. Januar #{@year}) wird automatisiert systemseitig ein Säumniszuschlag von 30 € berechnet."
      move_down par_distance 

      text "Der automatisierte Mahnungslauf für nicht abgegebene Meldebögen löst folgende Gebühren aus:"
      text "Die Mahngebühr der 1. Mahnung beträgt <b>10 €</b>, die der 2. Mahnung <b>20 €</b>.", inline_format: true
      move_down par_distance 

      text "Ihre Mitgliedsrechte ruhen solange Sie mit ihrer Melde- oder Beitragspflicht in Verzug sind. Es besteht dann kein Versicherungsschutz, es dürfen keine Konzerte über unseren GEMA-Rahmenvertrag gemeldet werden und es wird kein BDZ Magazin Auftakt! zugestellt."
      move_down par_distance 

      text "Wie bereits mitgeteilt sind diese Prozesse zur Mitgliederverwaltung inzwischen automatisiert und es ist nicht mehr möglich kulant auf die Erhebung von Säumniszuschlägen und Mahngebühren zu verzichten."
      move_down par_distance 

      text "Diese Gebühren werden nun automatisch nach Ablauf der jeweiligen Fristen / und nach automatisierter Auslösung der Mahnungen systemseitig erstellt und <b>erhoben</b>.", inline_format: true
      move_down par_distance 

      text "Bitte beachten Sie also unbedingt die Abgabefrist für die Meldebögen damit es nicht zu o.g. Säumniszuschlägen und Mahngebühren kommt!"
      move_down par_distance 

      text "Mit freundlichen Grüßen"
      text "Bund Deutscher Zupfmusiker e.V."
      move_down par_distance*3
      text from["name"]
      text from["dept"]
    end
  end
end
