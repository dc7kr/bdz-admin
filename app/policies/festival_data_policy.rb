# Default rules for festival data, see docs/permissions.md#festival-data
class FestivalDataPolicy < ApplicationPolicy
  allow :show?, to: %i[national festival]
  allow :create?, :update?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: raises instead of returning nil like the other scopes
      raise Pundit::NotAuthorizedError, "not allowed to view this action" unless permitted?(:national)

      scope.all
    end
  end

  # scope for the festival policies that festival users may list
  class FestivalScope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national, :festival)
    end
  end
end
