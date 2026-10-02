class UserPolicy < ApplicationPolicy
  allow :show?, to: %i[national regional_role]
  allow :create?, to: :national
  allow :update?, :destroy?, :add_role?, to: :admin

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:national)
    end
  end
end
