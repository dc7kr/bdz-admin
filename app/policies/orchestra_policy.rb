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
    result = (national_permission?)

    result
  end

  def show?
    national_permission? or user.has_role? :regional
  end

  def invoice_preview?
    user.has_role? :accounting or user.has_role? :admin
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end

  def update?
    national_permission?
  end
end
