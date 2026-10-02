class PersonMemberPolicy < ApplicationPolicy 
  attr_reader :user, :person_member
  def initialize(user, person_member)
    @user = user
    @person_member = person_member
  end

  def create?
    permitted?(:national)
  end

  def update?
    result = (permitted?(:national))

    result
  end

  def invoice_preview?
    permitted?(:accounting)
  end

  def show?
    permitted?(:national, :regional)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if permitted?(:member)

      if permitted?(:national)
        scope.for_user(user)
      elsif permitted?(:regional)
        scope.for_user(user)
      else
        scope.none
      end
    end
  end
end
