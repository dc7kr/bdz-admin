require 'ktoblzcheck'

class BlzValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)

    if ( ! value || value.length ==0 ) then
		if ( record.za == 'L' ) 
		then 
			record.errors[attribute] << ": "+(options[:message] || I18n.t("errors.blz.required_by_za"))
		end
		return
    end

	r=false
	KtoBlzCheck.new("/var/lib/ktoblzcheck1/bankdata.txt") do |kbc|
			name,location=kbc.find(record.blz)
			if name 
			then
				r=true
			else 
				r=false
			end
	end

#    r = blz >= 10000000 and blz <= 99999999
    record.errors[attribute] << (options[:message] || I18n.t("errors.blz.unknown")) unless r
  end
end
