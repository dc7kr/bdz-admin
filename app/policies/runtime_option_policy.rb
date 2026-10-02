# Runtime options are application settings, only admins see and change them.
class RuntimeOptionPolicy < ApplicationPolicy
  allow :index?, :show?, :update?, :destroy?, :reload?, to: :admin

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_if_permitted(:admin)
    end
  end
end
