class MemberDataPolicy < ApplicationPolicy
  attr_reader :user, :member_data_entity
  def initialize(user, member_data_entity)
    @user = user
    @member_data_entity = member_data_entity
  end

  def create?
    national_permission?
  end

  def update?
    national_permission?
  end

  def show?
    national_permission? or user.has_role? :regional
  end

  def destroy?
    national_permission?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end
end
