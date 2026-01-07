class MemberAccountBookingPolicy < ApplicationPolicy
  attr_reader :user, :member_account_booking

  def initialize(user, member_account_booking)
    @user = user
    @member_account_booking = member_account_booking
  end

  def create?
    user.has_role? :accounting or user.has_role? :admin
  end

  def update?
    user.has_role? :admin 
  end

  def show?
    national_permission? 
  end

  def destroy?
    user.has_role? :admin
  end

  def download?
    national_permission?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end
end
