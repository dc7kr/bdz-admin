class PublicDataPolicy < ApplicationPolicy

  def manage_permission?
    user.has_role? :admin or user.has_role? :national or user.has_role? :public_data
  end

  # anyone can create a public entity
  def create?
    true
  end

  def show?
    true
  end

  def update?
    manage_permission? 
  end

  def destroy?
    manage_permission?
  end
end
