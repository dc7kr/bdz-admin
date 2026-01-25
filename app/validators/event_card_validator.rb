class EventCardValidator < ActiveModel::Validator
  def validate(record)
    return if record.total_card_count.positive?

    record.errors.add(:base, :total_card_count_zero)
  end
end
