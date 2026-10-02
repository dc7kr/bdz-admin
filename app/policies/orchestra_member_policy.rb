class OrchestraMemberPolicy < MemberDataPolicy
  allow :index?, to: %i[national distinction]
  allow :show?, to: %i[national regional distinction]
  allow :exchange?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all if permitted?(:national, :distinction)
    end
  end
end
