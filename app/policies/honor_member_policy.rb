class HonorMemberPolicy < MemberDataPolicy
  attr_reader :user, :honor_member

  def initialize(user, honor_member)
    @user = user
    @honor_member = honor_member
  end

  def show?
    super or user.has_role? :distinction
  end

  def update?
    super or user.has_role? :distinction
  end

  def create?
    super or user.has_role? :distinction
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :distinction
        scope.all
      end
    end
  end
end
