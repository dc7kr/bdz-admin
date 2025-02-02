class BicValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      return unless record.has_attribute?(:za) && (record.za == 'L')

      record.errors.add attribute, I18n.t('errors.bic.required_for_dd')
      return

    end

    record.errors.add attribute, I18n.t('errors.bic.invalid_len') unless value.length == 11

    # only BIC lookup for DE works
    return if record.iban.blank? || !record.iban.start_with?('DE')

    record.errors.add attribute, I18n.t('errors.bic.unknown') unless BIC_FINDER.exist?(value)
  end
end
