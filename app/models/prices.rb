
class Prices 

	@@prices =  {
		'urkunden'=>4.5,
		'silbernadel'=>7,
		'goldnadel'=>7,
		'medaille'=>28,
		'ehrenbrief'=>19,
		'bundesnadel'=>6,
		'koop'=>50,
		'maxBeitrag'=>950,
		'minBeitrag'=>160,
		'zeitung'=>16,
		'uv'=>1.2,
		'mgebuehr1'=>10,
		'vzuschlag'=>30,
		'mgebuehr2'=>20,
		'hvgebuehrLv'=>8,
		'childrenRate'=>2.5,
		'teensRate'=>11,
		'youthRate'=>16,
		'adultRate'=>16,
		'uvRate'=>1.20 
	}
	def self.minBeitrag
		return @@prices['minBeitrag']
	end
	def self.childrenRate
		return @@prices['childrenRate']
	end
	def self.silbernadel
		return @@prices['silbernadel']
	end
	def self.goldnadel
		return @@prices['goldnadel']
	end
	def self.bundesnadel
		return @@prices['bundesnadel']
	end
	def self.maxBeitrag
		return @@prices['maxBeitrag']
	end
	def self.XXX
		return @@prices['XXX']
	end
	def self.XXX
		return @@prices['XXX']
	end
	def self.XXX
		return @@prices['XXX']
	end
	def self.XXX
		return @@prices['XXX']
	end
	def self.XXX
		return @@prices['XXX']
	end

	#beitraege
	def self.childrenRate 
		return @@prices['childrenRate']
	end
	def self.teensRate 
		return @@prices['teensRate']
	end
	def self.youthRate 
		return @@prices['youthRate']
	end
	def self.adultRate 
		return @@prices['adultRate']
	end
	def self.uvRate 
		return @@prices['uvRate']
	end
end
