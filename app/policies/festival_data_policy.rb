class FestivalDataPolicy < ApplicationPolicy
  attr_reader :user, :festival_data_entity
  def initialize(user, festival_data_entity)
    @user = user
    @festival_data_entity = festival_data_entity
  end

  def create?
    permitted?(:national)
  end

  def update?
    permitted?(:national)
  end

  def show?
    permitted?(:national, :festival)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national) 
        scope.all
      else
         raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end
end
