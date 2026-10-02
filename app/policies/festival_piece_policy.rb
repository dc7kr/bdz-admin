class FestivalPiecePolicy < FestivalDataPolicy
  allow :destroy?, to: :national

  class Scope < FestivalScope
  end
end
