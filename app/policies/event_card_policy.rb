class EventCardPolicy < FestivalDataPolicy

  def invoice_preview?
    national_permission?
  end
end
