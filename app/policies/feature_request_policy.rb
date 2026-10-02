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
      all_if_permitted(:signed_in)
    end
  end
end
