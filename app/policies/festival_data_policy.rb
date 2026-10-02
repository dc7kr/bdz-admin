# Default rules for festival data, see docs/permissions.md#festival-data
class FestivalDataPolicy < ApplicationPolicy
  allow :show?, to: %i[national festival]
  allow :create?, :update?, to: :national

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national)
    end
  end

  # scope for the festival policies that festival users may list
  class FestivalScope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :festival)
    end
  end
end
