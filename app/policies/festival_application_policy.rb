class FestivalApplicationPolicy < FestivalDataPolicy

  def show?
    super or user.has_role? :festival
  end
  
  class Scope < FestivalDataPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end
end
