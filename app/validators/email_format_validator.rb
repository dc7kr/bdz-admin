class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
	if  (! value || value.length == 0 ) then
		return
	end
    unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      object.errors[attribute] << (options[:message] || I18n.t("member.invalid_mail"))
    end
  end
end


