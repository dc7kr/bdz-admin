
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

	# honor
	def self.urkunden
		return BDZ_SETTINGS['honor']['urkunden'].to_f
	end
	def self.silbernadel
		return BDZ_SETTINGS['honor']['silbernadel'].to_f
	end
	def self.goldnadel
		return BDZ_SETTINGS['honor']['goldnadel'].to_f
	end
	def self.bundesnadel
		return BDZ_SETTINGS['honor']['bundesnadel'].to_f
	end
	def self.medaille
		return BDZ_SETTINGS['honor']['medaille'].to_f
	end
	def self.ehrenbrief
		return BDZ_SETTINGS['honor']['ehrenbrief'].to_f
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
end
