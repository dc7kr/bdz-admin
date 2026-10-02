class HonorMemberPolicy < MemberDataPolicy
  allow :show?, to: %i[national regional distinction]
  allow :create?, :update?, to: %i[national distinction]

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :distinction)
    end
  end
end
