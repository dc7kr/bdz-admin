class MealValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    if value.nil? then
      return
    end

    if attribute == :tln then
      unless value > 0
        record.errors[attribute] << I18n.t("activerecord.errors.models.event_meal.attributes.tln.at_least_one")
      end
    elsif attribute == :veg then
      if record.tln.nil? then
        return
      end

      unless value <= record.tln
        record.errors[attribute] << I18n.t("activerecord.errors.models.event_meal.attributes.veg.must_be_less_tln")
    end
  end
  end
end

