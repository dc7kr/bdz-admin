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
			name = name.force_encoding("ISO-8859-1").encode("UTF-8")
		    case kbc.check(record.blz,String(record.konto))
				when KtoBlzCheck::OK
					return
				when KtoBlzCheck::UNKNOWN
	  				record.errors[attribute] << ": "+(options[:message] || I18n.t("errors.konto.error"))
					record.errors[attribute] << name
					return
				when KtoBlzCheck::ERROR
	  				record.errors[attribute] << ": "+(options[:message] || I18n.t("errors.konto.invalid") + " ("+name+")") 
					return
				when KtoBlzCheck::BANK_NOT_KNOWN
	  				record.errors[attribute] << ": "+(options[:message] || I18n.t("errors.konto.bank_unknown")) 
					return
			end
		  end
	  end
  end
end
