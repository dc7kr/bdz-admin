class MagazineSamplingPolicy < ApplicationPolicy
  allow :show?, to: %i[national regional_role]
  allow :create?, :update?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national)
    end
  end
end
