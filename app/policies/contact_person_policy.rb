class ContactPersonPolicy < MemberDataPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end
end
