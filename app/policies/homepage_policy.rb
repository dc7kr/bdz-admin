class HomepagePolicy < ApplicationPolicy
  # anyone can create a public entity
  def create?
    true
  end

  def show?
    true
  end

  def self.editable_by?(user)
    permitted?(:admin)
  end

  def update?
    permitted?(:admin)
  end

  def destroy?
    permitted?(:admin)
  end

  def deletable_by?(user)
    permitted?(:admin)
  end

  def editable_by?(user)
    permitted?(:admin)
  end

  def updatable_by?(user)
    permitted?(:admin)
  end
end
