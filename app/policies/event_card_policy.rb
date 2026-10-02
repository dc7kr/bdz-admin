class EventCardPolicy < FestivalDataPolicy
  allow :invoice_preview?, :storno?, :pickup?, :overview?, to: :national
end
