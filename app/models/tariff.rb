class Tariff < ApplicationRecord

	def calcLvPart
		return amount*BDZ_SETTINGS['tariff']['lvPart']
	end

end
