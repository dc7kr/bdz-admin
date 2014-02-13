class BicValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)

    if value.blank? then 
      if record.za=='L' then
        record.errors.add attribute, I18n.t('errors.bic.required_for_dd')
        return
      else
        return
      end
    end

    if not BIC_FINDER.exists?(value) then
      record.errors.add attribute, I18n.t('errors.bic.unknown') 
    end
  end
end
