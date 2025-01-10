class MealValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    if attribute == :tln
      record.errors[attribute] << I18n.t('activerecord.errors.models.event_meal.attributes.tln.at_least_one') unless value > 0
    elsif attribute == :veg
      return if record.tln.nil?

      record.errors[attribute] << I18n.t('activerecord.errors.models.event_meal.attributes.veg.must_be_less_tln') unless value <= record.tln
    end
  end
end
