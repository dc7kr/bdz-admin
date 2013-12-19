class Tariff < ActiveRecord::Base

	def calcLvPart
		return amount*BDZ_SETTINGS['tariff']['lvPart']
	end

end
