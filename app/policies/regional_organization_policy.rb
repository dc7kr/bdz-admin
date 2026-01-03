class RegionalOrganizationPolicy < ApplicationPolicy
  def create?
    Rails.logger.debug("Static creatable check RO")
    user.has_role? :national
  end

  def update?
    Rails.logger.debug("Static updatable check RO")
    user.has_role? :national or user.has_role? :admin
  end

  def readable_by?(user)
    Rails.logger.debug("instance readable check RO")
    user.has_role? :national or user.has_role? :admin or user.has_role?(:regional, record)
  end

  def self.readable_by(user, scope = RegionalOrganization.all)
    Rails.logger.debug("Static readable check RO")
    if user.has_role?(:national) || user.has_role?(:admin)
      scope
    # elsif user.has_role? :regional
    else
      RegionalOrganization.with_role(:regional, user)
    end
  end
end
