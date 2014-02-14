class EventCardValidator < ActiveModel::Validator
  def validate(record)
    unless record.total_card_count >0 
      record.errors.add(:total_card_count,:zero)
    end
  end
end
