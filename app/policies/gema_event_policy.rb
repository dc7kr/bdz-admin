# GEMA events belong to an orchestra: national users manage them, regional users
# read the events of orchestras in their regional organization. Orchestra users
# read their own events in the member area (Mgl::GemaEventPolicy).
class GemaEventPolicy < MemberDataPolicy
  allow :index?, to: %i[national regional]

  def show?
    permitted?(:national) or (permitted?(:regional) and in_region?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national)
        scope.all
      elsif permitted?(:regional)
        scope.where(:orchestra_id.in => Orchestra.for_user(user).pluck(:id))
      else
        scope.none
      end
    end
  end

  private

  # authorize GemaEvent, :show? (no record) only checks the permission
  def in_region?
    return true if record.is_a?(Class)

    record.orchestra_id.present? and Orchestra.for_user(user).exists?(id: record.orchestra_id)
  end
end
