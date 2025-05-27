class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return unless value.is_a?(String)

    Rails.logger.debug value.class

    return if value.blank?

    return if value =~ /^[0-9]{1,2}\.[0-9]{1,2}\.20[0-9]{2} [0-9]{1,2}:[0-9]{1,2}.*$/

    object.errors.add(attribute, (options[:message] || I18n.t("common.invalid_datetime")))
  end
end
