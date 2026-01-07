class FestivalDataPolicy < ApplicationPolicy
  attr_reader :user, :festival_data_entity
  def initialize(user, festival_data_entity)
    @user = user
    @festival_data_entity = festival_data_entity
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

  # is ANY festival_data_entity readable by user - entity tests follow!
  def show?
    Rails.logger.debug("readable static: member data entity")
    national_permission? or user.has_role? :festival
  end

  class Scope < MemberDataPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end

  def update?
    national_permission?
  end
end
