class EventCardPolicy < FestivalDataPolicy

  def invoice_preview?
    permitted?(:national)
  end

  def storno?
    permitted?(:national)
  end

  def pickup?
    permitted?(:national)
  end

  def overview?
    permitted?(:national)
  end
end
