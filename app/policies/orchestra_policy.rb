class OrchestraPolicy < MemberDataPolicy
  allow :show?, to: %i[national regional distinction]
  allow :invoice_preview?, to: :accounting

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if permitted?(:member)

      permitted?(:national, :distinction, :regional) ? scope.for_user(user) : scope.none
    end
  end
end
