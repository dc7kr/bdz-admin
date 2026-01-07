class MagazineContextPolicy < ApplicationPolicy
  def create?
    national_permission?
  end

  def update?
    result = (national_permission?)
    Rails.logger.debug { "updatable class: #{result}" }

    result
  end

  def updatable_by?(user)
    result = (national_permission?)

    Rails.logger.debug { "updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}" }

    result
  end

  def show?
    national_permission?
  end

  def readable_by?(user)
    national_permission? or user.has_role? :distinction
  end
end
