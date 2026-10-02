class MemberDataPolicy < ApplicationPolicy
  attr_reader :user, :member_data_entity
  def initialize(user, member_data_entity)
    @user = user
    @member_data_entity = member_data_entity
  end
  
  def index?
    permitted?(:national)
  end

  def create?
    permitted?(:national)
  end

  def update?
    permitted?(:national)
  end

  def show?
    permitted?(:national, :regional)
  end

  def destroy?
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
