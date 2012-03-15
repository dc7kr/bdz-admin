class ReportSheet < ActiveRecord::Base
	belongs_to :orchestra
	def calcRawTariff
		return children*Prices.childrenRate + 
			youth*Prices.youthRate + 
			teens * Prices.teensRate + 
			adult * Prices.adultRate+
			senior * Prices.seniorRate
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
		return youth+teens+adult+senior
	end

	def calcUvCount
		if (uv) 
			return calcGemaCount+zusatz_uv
		else
			return 0
		end
	end

	def calcUV
		return calcUvCount * Prices.uvRate
	end

	def calcInvoice
		return calcUV+calcBeitrag
	end

	def calcZeitungen
		return (calcGemaCount*Prices.ztgRate).ceil
	end

end
