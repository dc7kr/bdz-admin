class OrchestraAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.is_admin? or user.has_role? :national
  end

  def self.creatable_by?(user)
    user.is_admin? or user.has_role? :national
  end

  def self.updatable_by?(user)
    result = (user.is_admin? or user.has_role? :national)
    Rails.logger.debug { "updatable class: #{result}" }

    result
  end

  def updatable_by?(user)
    result = (user.is_admin? or user.has_role? :national)

    Rails.logger.debug { "updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}" }

    result
  end

  # is ANY orchestra readable by user - entity tests follow!
  def self.readable_by?(user)
    Rails.logger.debug('readable static: Orchestra')
    user.is_admin? or user.has_role? :national or user.has_role? :regional
  end

  def readable_by?(user)
    user.is_admin? or user.has_role? :national or user.has_role? :distinction
  end
end
