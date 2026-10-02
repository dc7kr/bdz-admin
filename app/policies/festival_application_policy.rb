class FestivalApplicationPolicy < FestivalDataPolicy
  allow :destroy?, :fee_invoice_preview?, :fee_invoice?, :ticket_invoice_preview?, :gen_ticket_invoice?,
        :ticket_invoice?, :no_tickets?, :no_meals?, :finalize?, :storno?, :gen_participant_sheet?,
        :participant_overview?, to: :national
  allow :stage_plans?, :datasheets?, to: %i[national festival]

  class Scope < FestivalScope
  end
end
