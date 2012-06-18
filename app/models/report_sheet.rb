class ReportSheet < ActiveRecord::Base
	belongs_to :orchestra

    scope :current,
		lambda { { :conditions => ['year =  ?', String(Time.now.year)] } }

	def calcRawTariff
		return children*Prices.childrenRate + 
			youth*Prices.youthRate + 
			teens * Prices.teensRate + 
			adult * Prices.adultRate+
			senior * Prices.seniorRate
	end

	def calcBeitrag

		if (orchestra.orch_type == 'K' )
        then
           return Prices.koopRate
		elsif (orchestra.orch_type == 'L')
        then
            return Prices.lvOrchRate+(calcGemaCount)*Prices.lvMember
		end

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

	def totalActiveMembers
		# TODO: need a clean solution for the double members
		if orchestra.orch_type =='L' then
			return youth+teens+adult+senior
		else
			return youth+teens+adult+senior+azubi
		end
	end

	def calcGemaCount
		# TODO: need a clean solution for the double members
		if orchestra.orch_type =='L' then
			return youth+teens+adult+senior-azubi
		else
			return youth+teens+adult+senior
		end
	end

	def calcUvCount
		if (uv && orchestra.orch_type !='K') 
			return children+teens+youth+adult+senior+zusatz_uv
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

	def calcLvPart
		return calcBeitrag*0.15
	end

	def calcZeitungen
		if (orchestra.orch_type == 'L' ) then
			return 0
		end
		@ztg = (calcGemaCount*Prices.ztgRate).ceil
		if ( korr_ztg != nil ) then
			@ztg += korr_ztg;
		end
		return @ztg
	end

    # gema report sheet CSV
    comma :gema do
     calcGemaCount
   end


end
