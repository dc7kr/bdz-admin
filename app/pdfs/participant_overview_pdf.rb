require 'prawn'
class ParticipantOverviewPdf < Prawn::Document
  def initialize(participants, view)
    super(top_margin: 70)
    @participants = participants
    @view = view

    font 'Helvetica', size: 10
    heading
    participant_list
  end

  def format_ticket_list(event_card)
    invoice = event_card.invoice

    count = 0

    retval = ''
    invoice.items.each do |item|
      count += item.count if item.price.positive?
      retval += "#{item.count} #{item.label}\n"
    end
    retval += "GESAMT: #{count}"

    retval
  end

  def format_participants
    @result = []

    @result << ['Nr.', 'Name', 'Tickets', 'Solisten']

    @result += @participants.map do |item|
      [item.id,
       item.orch_name,
       format_ticket_list(item),
       item.soloist_tickets]
    end

    @result
  end

  def participant_list
    table format_participants do
      row(0).font_style = :bold
      columns(0).align = :right
      columns(1).align = :left
      columns(2..3).align = :right
      self.row_colors = %w[FFFFFF DDDDDD]
      self.header = true
      self.column_widths = { 0 => 50, 3 => 60 }
    end
  end

  def heading
    text 'Festival-Teilnehmer', size: 30, style: :bold
    text "Stand: #{Time.zone.now.strftime '%d.%m.%Y %H:%M Uhr'}", size: 20
  end
end
