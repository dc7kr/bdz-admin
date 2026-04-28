class EventCardPolicy < FestivalDataPolicy

  def invoice_preview?
    national_permission?
  end

  def storno?
    national_permission?
  end

  def overview?
    national_permission?
  end
end
