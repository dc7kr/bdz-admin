class FestivalExhibitorPolicy < FestivalDataPolicy

  def show?
    super or permitted?(:festival)
  end

  def invoice_preview?
    permitted?(:national)
  end

  def gen_invoice?
    permitted?(:national)
  end

  def storno?
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
