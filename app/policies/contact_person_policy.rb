class ContactPersonPolicy < MemberDataPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :festival)
    end
  end
end
