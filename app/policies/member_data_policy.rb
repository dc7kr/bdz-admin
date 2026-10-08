# Default rules for member data, see docs/permissions.md#member-data
class MemberDataPolicy < ApplicationPolicy
  allow :index?, to: :national
  allow :show?, to: %i[national regional]
  allow :create?, :update?, :destroy?, to: :national

  # open the member area in the name of the member, see Mgl::Impersonation
  def impersonate?
    Mgl::Impersonation.allowed?(user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national)
    end
  end
end
