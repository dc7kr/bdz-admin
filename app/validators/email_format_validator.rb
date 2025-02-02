class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value.blank?

    return if value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

    object.errors.add(attribute, (options[:message] || I18n.t('member.invalid_mail')))
  end
end
