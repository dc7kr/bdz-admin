class MealValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    if attribute == :tln
      record.errors.add(attribute, :at_least_one) unless value.positive?
    elsif attribute == :veg
      return if record.tln.nil?
      record.errors.add(attribute, :must_be_leq_tln) unless value <= record.tln
    end
  end
end
