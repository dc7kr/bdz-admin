class MemberAccountBookingPolicy < ApplicationPolicy
  attr_reader :user, :member_account_booking

  def initialize(user, member_account_booking)
    @user = user
    @member_account_booking = member_account_booking
  end

  def create?
    permitted?(:accounting)
  end

  def update?
    permitted?(:admin) or (permitted?(:accounting) and member_account_booking.booking_mode == "M")
  end

  def show?
    permitted?(:national) 
  end

  def destroy?
    permitted?(:admin)
  end

  def invoice_preview?
    permitted?(:accounting)
  end

  def invoice_sepa?
    permitted?(:accounting)
  end

  def download?
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
