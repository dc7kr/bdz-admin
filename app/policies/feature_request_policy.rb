class FeatureRequestPolicy < ApplicationPolicy 
  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    record.user == user or user.has_role? :admin
  end

  def update?
    user.present? and (record.user == user or user.has_role? :admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present?
        scope.all
      else
        false
      end
    end
  end
end
