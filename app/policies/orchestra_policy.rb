class OrchestraPolicy < MemberDataPolicy
  attr_reader :user, :orchestra
  def initialize(user, orchestra)
    @user = user
    @orchestra = orchestra
  end

  def create?
    national_permission?
  end

  def update?
    national_permission?
  end

  def show?
    national_permission? or user.regional_level? or user.has_role? :distinction
  end

  def invoice_preview?
    user.has_role? :accounting or user.has_role? :admin
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.member_level?

      if national_permission? or user.has_role? :distinction
        scope.for_user(user)
      elsif user.regional_level?
        scope.for_user(user)
      else
        scope.none
      end
    end
  end
end
