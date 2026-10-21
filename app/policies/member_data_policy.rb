# Default rules for member data, see docs/permissions.md#member-data
class MemberDataPolicy < ApplicationPolicy
  allow :index?, to: :national
  allow :show?, to: %i[national regional]
  allow :create?, :update?, :destroy?, to: :national

  # open the member area in the name of the member, see Mgl::Impersonation
  def impersonate?
    Mgl::Impersonation.allowed?(user)
  end

  # invite the member to the member area (set a password), see Mgl::InvitationsController
  def invite?
    permitted?(:national)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national)
    end
  end
end
