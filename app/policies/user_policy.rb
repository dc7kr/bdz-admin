class UserPolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create?
    national_permission?
  end

  def update?
    result = (national_permission?)

    result
  end

  def destroy?
    user.has_role? :admin
  end
        

  def show?
    Rails.logger.debug("readable static: member data entity")
    national_permission? or user.has_role? :regional
  end

  def add_role?
    user.has_role? :admin
  end

  class Scope < MemberDataPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end

  def update?
    user.has_role? :admin 
  end
end
