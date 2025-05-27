require "prawn"
class TicketOrderOverviewPdf < Prawn::Document
  def initialize(event_cards, view)
    super(top_margin: 70)
    @event_cards = event_cards
    @view = view

    font "Helvetica", size: 10
    heading
    ticket_list
  end

  def format_ticket_list(event_card)
    invoice = event_card.invoice

    retval = ""
    invoice.items.each do |item|
      retval += "#{item.count} #{item.label}\n"
    end

    retval
  end

  def render_payed(item)
    if item.payment_received
      "x"
    else
      ""
    end
  end

  def format_orders
    @result = []

    @result << [ "Nr.", "Name", "Tickets", "Summe", "Bezahlt" ]

    @result += @event_cards.map do |item|
      [ item.id,
       item.name,
       format_ticket_list(item),
       @view.format_currency(item.invoice.sum),
       render_payed(item) ]
    end

    @result
  end

  def ticket_list
    table format_orders do
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
    text "Kartenbestellungen", size: 30, style: :bold
    text "Stand: #{Time.zone.now.strftime '%d.%m.%Y %H:%M Uhr'}", size: 20
  end
end
