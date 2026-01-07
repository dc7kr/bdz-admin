class FestivalConcertPolicy < FestivalDataPolicy
  def programme? 
    national_permission? or user.has_role :festival
  end
end
