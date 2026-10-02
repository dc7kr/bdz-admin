class HonorMemberPolicy < MemberDataPolicy
  attr_reader :user, :honor_member

  def initialize(user, honor_member)
    @user = user
    @honor_member = honor_member
  end

  def show?
    super or permitted?(:distinction)
  end

  def update?
    super or permitted?(:distinction)
  end

  def create?
    super or permitted?(:distinction)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national, :distinction)
        scope.all
      end
    end
  end
end
