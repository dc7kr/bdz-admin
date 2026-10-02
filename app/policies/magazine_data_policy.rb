# Default rules for magazine data, see docs/permissions.md#magazine
class MagazineDataPolicy < ApplicationPolicy
  allow :index?, :show?, :create?, :update?, :destroy?, to: %i[national magazine]

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national, :magazine)
    end
  end
end
