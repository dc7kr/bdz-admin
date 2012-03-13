class ReportSheet < ActiveRecord::Base
	belongs_to :orchestra

	def calcRawTariff
		return children*Prices.childrenRate + 
			youth*Prices.youthRate + 
			teens * Prices.teensRate + 
			adult * Prices.adultRate
	end

	def calcBeitrag
		val = calcRawTariff

		if ( val < Prices.minTariff ) 
			return Prices.minTariff
		end
		if ( val > Prices.maxTariff ) 
			return Prices.maxTariff
		end
		return val
	end

	def isMinTariff?
		return calcRawTariff < Prices.minTariff
	end

	def isMaxTariff?
		return calcRawTariff > Prices.maxTariff
	end

	def calcGemaCount
		return youth+teens+adult
	end

	def calcUvCount
		return calcGemaCount
	end

	def calcUV
		return calcUvCount * Prices.uvRate
	end

	def calcInvoice
		return calcUV+calcBeitrag
	end

end
