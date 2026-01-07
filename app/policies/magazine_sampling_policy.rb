class MagazineSamplingPolicy < ApplicationPolicy 
  attr_reader :user, :magazine_sampling
  def initialize(user, magazine_sampling)
    @user = user
    @magazine_sampling = magazine_sampling
  end

  def create?
    national_permission?
  end

  def update?
    result = (national_permission?)

    result
  end

  def updatable_by?(user)
    result = (national_permission?)

    Rails.logger.debug { "updatable: admin?: #{user.is_admin?} national: #{user.has_role? :national} : #{result}" }

    result
  end

  # is ANY magazine_sampling readable by user - entity tests follow!
  def show?
    Rails.logger.debug("readable static: MagazineSampling")
    national_permission? or user.has_role? :regional
  end

  def readable_by?(user)
    national_permission? 
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end

  def update?
    national_permission?
  end
end
