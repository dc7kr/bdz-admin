class PersonMemberPolicy < MemberDataPolicy
  # TODO: index? and destroy? are denied for everybody, unlike the other member data
  allow :index?, :destroy?, to: []
  allow :invoice_preview?, to: :accounting

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if permitted?(:member)

      permitted?(:national, :regional) ? scope.for_user(user) : scope.none
    end
  end
end
