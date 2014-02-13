class BicValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)


    if value.blank? then 
      return
    end

    if not BIC_FINDER.exists?(value) then
      record.errors.add attribute, I18n.t('errors.bic.unknown') 
    end
  end
end
