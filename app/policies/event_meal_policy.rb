class EventMealPolicy < FestivalDataPolicy
  def arrival_overview?
    permitted?(:national, :festival)
  end


  class Scope < FestivalDataPolicy::Scope
    def resolve
      if permitted?(:national, :festival)
        scope.all
      end
    end
  end
end
