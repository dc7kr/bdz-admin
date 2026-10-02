class DistinctionPolicy < MemberDataPolicy
  allow :show?, :create?, to: %i[national distinction]
  allow :invoice_preview?, :gen_invoice?, to: %i[accounting distinction]

  # booked distinctions may only be changed by admins
  def update?
    permitted?(:admin) or (record.member_account_booking.nil? and permitted?(:national, :distinction))
  end

  def destroy?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :distinction)
    end
  end
end
