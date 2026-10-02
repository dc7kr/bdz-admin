class MemberAccountBookingPolicy < ApplicationPolicy
  allow :show?, to: :national
  allow :create?, :invoice_preview?, :invoice_sepa?, to: :accounting
  allow :destroy?, to: :admin
  allow :download?, to: %i[national distinction]

  # admins may edit any booking, accounting users only manual bookings
  def update?
    permitted?(:admin) or (permitted?(:accounting) and record.booking_mode == "M")
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national, :distinction)
    end
  end
end
