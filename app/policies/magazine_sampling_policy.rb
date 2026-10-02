class MagazineSamplingPolicy < ApplicationPolicy 
  attr_reader :user, :magazine_sampling
  def initialize(user, magazine_sampling)
    @user = user
    @magazine_sampling = magazine_sampling
  end

  def create?
    permitted?(:national)
  end

  def update?
    result = (permitted?(:national))

    result
  end

  def updatable_by?(user)
    result = (permitted?(:national))

    Rails.logger.debug { "updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}" }

    result
  end

  # is ANY magazine_sampling readable by user - entity tests follow!
  def show?
    Rails.logger.debug("readable static: MagazineSampling")
    permitted?(:national, :regional_role)
  end

  def readable_by?(user)
    permitted?(:national) 
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national)
        scope.all
      end
    end
  end
end
