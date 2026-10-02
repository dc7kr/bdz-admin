class PersonMemberPolicy < ApplicationPolicy 
  attr_reader :user, :person_member
  def initialize(user, person_member)
    @user = user
    @person_member = person_member
  end

  def create?
    national_permission?
  end

  def update?
    result = (national_permission?)

    result
  end

  def invoice_preview?
    user.has_role? :accounting or user.has_role? :admin
  end

  def show?
    national_permission? or user.regional_level?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.member_level?

      if national_permission?
        scope.for_user(user)
      elsif user.regional_level?
        scope.for_user(user)
      else
        scope.none
      end
    end
  end
end
