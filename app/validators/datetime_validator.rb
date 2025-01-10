class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return unless value.is_a?(String)

    Rails.logger.debug value.class

    return if !value || value.length == 0

    return if value =~ /^[0-9]{1,2}\.[0-9]{1,2}\.20[0-9]{2} [0-9]{1,2}:[0-9]{1,2}.*$/

    object.errors[attribute] << (options[:message] || I18n.t('common.invalid_datetime'))
  end
end
