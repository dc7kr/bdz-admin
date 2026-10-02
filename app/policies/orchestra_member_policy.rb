class OrchestraMemberPolicy < MemberDataPolicy
  allow :index?, to: %i[national distinction]
  allow :show?, to: %i[national regional distinction]
  allow :exchange?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :distinction)
    end
  end
end
