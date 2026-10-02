class ContactPersonPolicy < MemberDataPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national, :festival)
    end
  end
end
