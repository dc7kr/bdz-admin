class EventMealPolicy < FestivalDataPolicy
  def arrival_overview?
    national_permission or user.has_role? :festival
  end


  class Scope < FestivalDataPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end
end
