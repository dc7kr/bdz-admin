
class Prices 

	# fees
	def self.mgebuehr1 
		return BDZ_SETTINGS['fees']['mgebuehr1']
	end

	def self.mgebuehr2
		return BDZ_SETTINGS['fees']['mgebuehr2']
	end

	def self.vzuschlag
		return BDZ_SETTINGS['fees']['mgebuehr2']
	end

	# distinctions
	def self.certificate
		return BDZ_SETTINGS['distinction_prices']['certificate'].to_f
	end
	def self.silverNeedle
		return BDZ_SETTINGS['distinction_prices']['silverneedle'].to_f
	end
	def self.goldenNeedle
		return BDZ_SETTINGS['distinction_prices']['goldenneedle'].to_f
	end
	def self.nationalNeedle
		return BDZ_SETTINGS['distinction_prices']['nationalneedle'].to_f
	end
	def self.medal
		return BDZ_SETTINGS['distinction_prices']['medal'].to_f
	end
	def self.honorLetter
		return BDZ_SETTINGS['distinction_prices']['honorletter'].to_f
	end
	def self.distinctionPorto
		return BDZ_SETTINGS['distinction_prices']['porto'].to_f
	end

	#beitraege
	def self.childrenRate 
		return BDZ_SETTINGS['tariff']['childrenRate'].to_f
	end

	def self.teensRate 
		return BDZ_SETTINGS['tariff']['teensRate'].to_f
	end

	def self.youthRate 
		return BDZ_SETTINGS['tariff']['youthRate'].to_f
	end

	def self.adultRate 
		return BDZ_SETTINGS['tariff']['adultRate'].to_f
	end

	def self.seniorRate
		return BDZ_SETTINGS['tariff']['adultRate'].to_f
	end

	def self.uvRate 
		return BDZ_SETTINGS['tariff']['uvRate'].to_f
	end

	def self.minTariff
		return BDZ_SETTINGS['tariff']['minBeitrag'].to_f
	end

	def self.maxTariff
		return BDZ_SETTINGS['tariff']['maxBeitrag'].to_f
	end

	def self.zeitung
		return BDZ_SETTINGS['tariff']['zeitung'].to_f
	end
	def self.uvRate
		return BDZ_SETTINGS['tariff']['uv'].to_f
	end
	def self.hvLvRate
		return BDZ_SETTINGS['tariff']['hvgebuehrLv'].to_f
	end
	def self.lvOrchRate
		return BDZ_SETTINGS['tariff']['lvOrch'].to_f
	end
	def self.lvMember
		return BDZ_SETTINGS['tariff']['lvMember'].to_f
	end
	def self.koopRate
		return BDZ_SETTINGS['tariff']['koop'].to_f
	end

  	def self.ztgRate
		return  BDZ_SETTINGS['tariff']['ztgRate'].to_f
	end

  def self.loZtgCount
		return  BDZ_SETTINGS['tariff']['loZtgCount'].to_f
	end
end
