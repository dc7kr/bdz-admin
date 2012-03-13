require 'ktoblzcheck'

class KontoValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    if ( ! value || value == 0 ) then
		if ( record.za == 'L' ) 
		then 
			record.errors[attribute] << (options[:message] || I18n.t("errors.konto.required_by_za")) 
		end
		return
    end
	 r=false
	 KtoBlzCheck.new do |kbc|
		  name,location=kbc.find(record.blz)
		  if name 
		    if kbc.check(record.blz,String(record.konto)) == KtoBlzCheck::OK
		    then 
		      r=true
		    else
		      r=false
		    end
		  else
		    r = false
		  end
	  end
	  record.errors[attribute] << (options[:message] || I18n.t("errors.konto.invalid")) unless r
  end
end
