class RegionalOrganizationAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role? :national
  end

  def self.readable_by?(user)
    user.has_role? :national or user.has_role? :admin
  end

  def self.updatable_by?(user)
    user.has_role? :national or user.has_role? :admin
  end
end
