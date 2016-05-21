class OrchestraAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.is_admin? or user.has_role? :national
  end
  
  def self.creatable_by?(user)
    user.is_admin? or user.has_role? :national
  end

  def self.updatable_by?(user)
    result = (user.is_admin? or user.has_role? :national)
    Rails.logger.debug("updatable class: #{result}")

    result
  end

  def updatable_by?(user)
    result = (user.is_admin? or user.has_role? :national)

    Rails.logger.debug("updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}")

    result
  end
end
