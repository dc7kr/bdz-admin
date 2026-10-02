class OrchestraPolicy < MemberDataPolicy
  attr_reader :user, :orchestra
  def initialize(user, orchestra)
    @user = user
    @orchestra = orchestra
  end

  def create?
    permitted?(:national)
  end

  def update?
    permitted?(:national)
  end

  def show?
    permitted?(:national, :regional, :distinction)
  end

  def invoice_preview?
    permitted?(:accounting)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if permitted?(:member)

      if permitted?(:national, :distinction)
        scope.for_user(user)
      elsif permitted?(:regional)
        scope.for_user(user)
      else
        scope.none
      end
    end
  end
end
