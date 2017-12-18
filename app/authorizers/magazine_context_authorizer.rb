class MagazineContextAuthorizer < ApplicationAuthorizer
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

  def self.readable_by?(user) 
    user.is_admin? or user.has_role? :national
  end

  def readable_by?(user)
    user.is_admin? or user.has_role? :national or user.has_role? :distinction
  end
end
