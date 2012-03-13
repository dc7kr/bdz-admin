class OrchMglnrValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
	if (! value )
		record.errors[attribute] << (options[:message] || I18n.t("errors.mglnr.required"))
		return
	else
      nr = value

		r=false
      digit = (nr % 1000 ) / 100

		if ( record.landes_orch == true && digit != 2) 
		then 
			record.errors[attribute] << (options[:message] || I18n.t("errors.mglnr.require_land_orch")) 
		elsif (record.koopMitglied == true && digit != 1 ) 
		then
			record.errors[attribute] << (options[:message] || I18n.t("errors.mglnr.require_koop")) 
		else
			r=true
		end
	  record.errors[attribute] << (options[:message] || I18n.t("errors.mglnr.invalid")) unless r
	end
  end
end
