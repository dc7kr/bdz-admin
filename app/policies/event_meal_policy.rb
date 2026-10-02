class EventMealPolicy < FestivalDataPolicy
  allow :arrival_overview?, to: %i[national festival]

  class Scope < FestivalScope
  end
end
