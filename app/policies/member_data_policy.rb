# Default rules for member data, see docs/permissions.md#member-data
class MemberDataPolicy < ApplicationPolicy
  allow :index?, to: :national
  allow :show?, to: %i[national regional]
  allow :create?, :update?, :destroy?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national)
    end
  end
end
