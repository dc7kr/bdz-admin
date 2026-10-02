class FeatureRequestPolicy < ApplicationPolicy
  allow :show?, :create?, to: :signed_in

  def update?
    permitted?(:signed_in) and (record.user == user or permitted?(:admin))
  end

  def destroy?
    record.user == user or permitted?(:admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: returns false instead of nil like the other scopes
      permitted?(:signed_in) ? scope.all : false
    end
  end
end
