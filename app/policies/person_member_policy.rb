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
    national_permission? or user.has_role? :regional
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
