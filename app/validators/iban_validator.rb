class IbanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # record.errors.add attribute, I18n.t('errors.iban.required') if value.blank?

    if value.blank?
      return unless record.has_attribute?(:za) and record.za == 'L'

      record.errors.add attribute, I18n.t('errors.iban.required_for_dd')
      return

    end

    # IBAN code should start with country code (2letters)
    record.errors.add attribute, I18n.t('errors.iban.cc_missing') unless value.to_s =~ /^[A-Z]{2}/i
    iban = value.gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
    return if (iban[6..iban.length - 1].to_s + iban[0..5].to_s).to_i % 97 == 1

    record.errors.add attribute,
                      I18n.t('errors.iban.invalid_format')
  end
end
