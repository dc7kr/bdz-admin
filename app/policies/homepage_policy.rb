class HomepagePolicy < ApplicationPolicy
  # anyone can create a public entity
  def create?
    true
  end

  def show?
    true
  end

  def self.editable_by?(user)
    user.has_role? :admin
  end

  def update?
    user.has_role? :admin
  end

  def destroy?
    user.has_role? :admin
  end

  def deletable_by?(user)
    user.has_role? :admin
  end

  def editable_by?(user)
    user.has_role? :admin
  end

  def updatable_by?(user)
    user.has_role? :admin
  end
end
