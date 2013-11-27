class ReportSheet < ActiveRecord::Base

  validates_presence_of :report_date , :unless => lambda { self.orchestra.blank? }
  validates_presence_of :adult
  validates_presence_of :adult_ens
  validates_presence_of :azubi
  validates_presence_of :chamber_ens
  validates_presence_of :child_ens
  validates_presence_of :children
  validates_presence_of :passive
  validates_presence_of :senior
  validates_presence_of :senior_ens
  validates_presence_of :teens
  validates_inclusion_of :uv, :in => [true,false]
  validates_presence_of :youth
  validates_presence_of :youth_ens
  validates_presence_of :zusatz_uv
  validates_presence_of :zusatz_ztg



	scope :final, lambda { |year| where('year = ? and orchestra_id is not null', year) }
	scope :not_final, where(:orchestra_id=> nil)
	belongs_to :orchestra



    scope :current,
		lambda { { :conditions => ['year =  ?', String(Time.now.year)] } }

	def self.age_categories
		@@age_categories = ["C","T","Y","A","S"]
	end

	def init_empty
		self.adult ||=0 
		self.adult_ens ||=0
		self.azubi ||=0
		self.chamber_ens ||=0
		self.child_ens ||=0
		self.children ||=0
		self.korr_ztg ||=0
		self.other_ens ||=0
		self.passive ||=0
		self.senior ||=0
		self.senior_ens ||=0
		self.teens ||=0
		self.token ||=0
		if self.uv.nil? then self.uv=false else logger.debug "UV was not nil" end
		self.youth ||=0
		self.youth_ens ||=0
		self.zusatz_uv ||=0
		self.zusatz_ztg ||=0
	end

	def self.new_for_year(year)
		@report_sheet = ReportSheet.new
		@report_sheet.init_empty
		@report_sheet.orchestra=nil
		@report_sheet.year=year

		@report_sheet
	end

	def self.for_orchestra_and_year(orchestra,year)

		@report_sheet = ReportSheet.where("orchestra_id = ? and year = ?",orchestra.id, year).first

		if ( @report_sheet == nil ) then 
			@report_sheet = ReportSheet.new
			@report_sheet.init_empty
			@report_sheet.orchestra=orchestra
			@report_sheet.year=year
		end

		return @report_sheet
	end

    def report_date_str=(newval)
  		self.report_date = Date.parse_with_i18n(newval)
    end

    def report_date_str
	    if report_date then
	      I18n.l(report_date)
	    else
			  ""
      end
    end

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

    sum = calcUV+calcBeitrag

    if delayed?
      sum+=Prices.delayFee
    end
    return sum
	end

	def calcLvPart
		return calcBeitrag*0.15
	end

	def calcZeitungen
		if (orchestra.orch_type == 'L' ) then
			return Prices.loZtgCount
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

   def ageKeyStr
    str ="|"
    str+= children.to_s+"|"
    str+= teens.to_s+"|"
    str+= youth.to_s+"|"
    str+= adult.to_s+"|"
    str+= senior.to_s+"|"

    str
   end

  def delayed?
    return report_date.month > 1
  end




#	TODO: def scoped for easier retrieval!
#   def orchestras 
#    Orchestra.scoped(:joins => {:user => :memberships}, :conditions => { :memberships => { :group_id => id } })
#   end
end
