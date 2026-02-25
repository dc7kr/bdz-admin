class FestivalConcertPolicy < FestivalDataPolicy
  def programme? 
    national_permission? or user.has_role? :festival
  end

  def destroy?
    national_permission?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end
end
