class BicValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)


    if value.blank? then 
      if record.has_attribute?(:za) and record.za=='L' then
        record.errors.add attribute, I18n.t('errors.bic.required_for_dd')
        return
      else
        return
      end
    end

    record.errors.add attribute, I18n.t('errors.bic.invalid_len') unless value.length == 11

    # only BIC lookup for DE works 
    if record.iban.nil? or record.iban.empty? or not record.iban.start_with? "DE" then
      return
    end
    if not BIC_FINDER.exist?(value) then
      record.errors.add attribute, I18n.t('errors.bic.unknown') 
    end
  end
end
