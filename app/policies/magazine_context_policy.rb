class MagazineContextPolicy < ApplicationPolicy
  def create?
    permitted?(:national)
  end

  def update?
    result = (permitted?(:national))
    Rails.logger.debug { "updatable class: #{result}" }

    result
  end

  def updatable_by?(user)
    result = (permitted?(:national))

    Rails.logger.debug { "updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}" }

    result
  end

  def show?
    permitted?(:national)
  end

  def readable_by?(user)
    permitted?(:national, :distinction)
  end
end
