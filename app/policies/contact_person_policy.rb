class ContactPersonPolicy < MemberDataPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national, :festival)
        scope.all
      end
    end
  end
end
