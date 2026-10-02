class FestivalPiecePolicy < FestivalDataPolicy
  def show?
    super or permitted?(:festival)
  end

  def destroy?
    permitted?(:national)
  end

  
  class Scope < FestivalDataPolicy::Scope
    def resolve
      if permitted?(:national, :festival)
        scope.all
      end
    end
  end
end
