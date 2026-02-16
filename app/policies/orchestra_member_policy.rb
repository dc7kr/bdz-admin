class OrchestraMemberPolicy < MemberDataPolicy

  def exchange?
    national_permission?
  end

  def index
    super or user.has_role? :distinction
  end

  def show
    super or user.has_role? :distinction
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :distinction
        scope.all
      end
    end
  end

end
