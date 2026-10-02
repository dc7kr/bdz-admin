class ContactEventPolicy < MemberDataPolicy

  class Scope < ApplicationPolicy::Scope
    def resolve
      if permitted?(:national) 
        scope.all
      end
    end
  end
end
