class FeatureRequestPolicy < ApplicationPolicy 
  def show?
    permitted?(:signed_in)
  end

  def create?
    permitted?(:signed_in)
  end

  def destroy?
    record.user == user or permitted?(:admin)
  end

  def update?
    permitted?(:signed_in) and (record.user == user or permitted?(:admin))
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:signed_in)
        scope.all
      else
        false
      end
    end
  end
end
