class ContactEventPolicy < ApplicationPolicy 
  class Scope < ApplicationPolicy::Scope
    def resolve
      if national_permission?
        scope.all
      end
    end
  end
end
