class MemberPolicy < ApplicationPolicy
  def create?
    user.has_role? :national
  end

  def update?
    user.has_role? :national or user.has_role? :admin
  end
end
