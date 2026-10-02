class DistinctionPolicy < MemberDataPolicy
  attr_reader :user, :distinction

  def initialize(user, distinction)
    @user = user
    @distinction = distinction
  end

  def show? 
    permitted?(:national, :distinction)
  end

  def invoice_preview?
    permitted?(:accounting, :distinction)
  end

  def gen_invoice?
    permitted?(:accounting, :distinction)
  end

  def destroy?
    permitted?(:admin) or (distinction.member_account_booking == nil and permitted?(:national, :distinction))
  end

  def update?
    permitted?(:admin) or (distinction.member_account_booking == nil and permitted?(:national, :distinction))
  end

  def create?
    permitted?(:national, :distinction)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national, :distinction)
        scope.all
      end
    end
  end

end
