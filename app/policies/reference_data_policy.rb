# Default rules for reference data, see docs/permissions.md#reference-data
class ReferenceDataPolicy < ApplicationPolicy
  allow :index?, :show?, to: :signed_in
  allow :create?, :update?, :destroy?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:signed_in)
    end
  end
end
