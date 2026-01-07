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
    national_permission?
  end

  def show?
    national_permission? or user.has_role? :festival
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? 
        scope.all
      end
    end
  end
end
