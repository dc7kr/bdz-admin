class PublicEntityPolicy < ApplicationPolicy
  # anyone can create a public entity
  def create?
    true
  end

  def show?
    true
  end

  def self.editable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def update?
    user.has_role? :admin or user.has_role? :national
  end

  def destroy?
    user.has_role? :admin or user.has_role? :national
  end

  def deletable_by?(user)
    user.has_role? :admin
  end

  def editable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end

  def updatable_by?(user)
    user.has_role? :admin or user.has_role? :national
  end
end
