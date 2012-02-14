class ReportSheet < ActiveRecord::Base
	belongs_to :orchestra

	# calculate Beitrag 
	def calcBeitrag
		val = children*Prices.childrenRate + 
			youth*Prices.youthRate + 
			teens * Prices.teensRate + 
			adult * Prices.adultRate
		if ( val < Prices.minBeitrag ) 
			return Prices.minBeitrag
		end
		if ( val > Prices.maxBeitrag ) 
			return Prices.maxBeitrag
		end
		return val
	end

	def calcUV
		return (children+youth+teens+adult) * Prices.uvRate
	end
	def calcInvoice
		return calcUV+calcBeitrag
	end

end
