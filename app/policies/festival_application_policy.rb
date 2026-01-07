class FestivalApplicationPolicy < FestivalDataPolicy

  def show?
    super or user.has_role? :festival
  end

  def fee_invoice_preview?
    national_permission? 
  end
 
  def fee_invoice?
    national_permission? 
  end

  def ticket_invoice_preview?
    national_permission? 
  end

  def ticket_invoice?
    national_permission? 
  end

  def finalize?
    national_permission? 
  end

  def gen_participant_sheet?
    national_permission? 
  end

  class Scope < FestivalDataPolicy::Scope
    def resolve
      if national_permission? or user.has_role? :festival
        scope.all
      end
    end
  end
end
