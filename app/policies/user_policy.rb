class UserPolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create?
    permitted?(:national)
  end

  def update?
    permitted?(:admin)
  end

  def destroy?
    permitted?(:admin)
  end
        

  def show?
    Rails.logger.debug("readable static: member data entity")
    permitted?(:national, :regional_role)
  end

  def add_role?
    permitted?(:admin)
  end

  class Scope < MemberDataPolicy::Scope
    def resolve
      if permitted?(:national)
        scope.all
      end
    end
  end
end
