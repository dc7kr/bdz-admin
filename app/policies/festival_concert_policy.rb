class FestivalConcertPolicy < FestivalDataPolicy
  allow :destroy?, to: :national
  allow :programme?, :details?, to: %i[national festival]

  class Scope < FestivalScope
  end
end
