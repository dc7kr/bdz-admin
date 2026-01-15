class DistinctionPolicy < MemberDataPolicy
  attr_reader :user, :distinction

  def initialize(user, distinction)
    @user = user
    @distinction = distinction
  end

  def show? 
    national_permission? or user.has_role? :distinction
  end

  def invoice_preview?
    accounting_permission? or user.has_role? :distinction
  end

  def gen_invoice?
    accounting_permission? or user.has_role? :distinction
  end

  def destroy?
    distinction.member_account_booking == nil or user.has_role? :admin 
  end

  def update?
    user.has_role? :admin or (distinction.member_account_booking == nil and (user.has_role? :national or user.has_role? :distinction))
  end

  def create?
    national_permission? or user.has_role? :distinction
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :distinction
        scope.all
      end
    end
  end

end
