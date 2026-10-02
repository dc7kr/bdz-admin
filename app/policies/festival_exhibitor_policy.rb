class FestivalExhibitorPolicy < FestivalDataPolicy
  allow :invoice_preview?, :gen_invoice?, :storno?, to: :national

  class Scope < FestivalScope
  end
end
