class FestivalConcertPolicy < FestivalDataPolicy
  def programme?
    permitted?(:national, :festival)
  end

  def destroy?
    permitted?(:national)
  end

  def details?
    permitted?(:national, :festival)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national, :festival)
        scope.all
      end
    end
  end
end
