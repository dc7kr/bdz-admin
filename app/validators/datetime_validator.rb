class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if ! value.is_a?(String) then
      return
    else
      Rails.logger.debug value.class
    end
	if  (! value || value.length == 0 ) then
		return
	end
    unless value =~ /^[0-9]{1,2}\.[0-9]{1,2}\.20[0-9]{2} [0-9]{1,2}:[0-9]{1,2}.*$/
      object.errors[attribute] << (options[:message] || I18n.t("common.invalid_datetime"))
    end
  end
end


