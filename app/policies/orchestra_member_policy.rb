class OrchestraMemberPolicy < MemberDataPolicy

  def exchange?
    permitted?(:national)
  end

  def index?
    super or permitted?(:distinction)
  end

  def show?
    super or permitted?(:distinction)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national, :distinction)
        scope.all
      end
    end
  end

end
