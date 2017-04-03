require 'rodf'
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

  has_one :member, through: :orchestra

  has_one :regional_organization, through: :member

  def self.for_regional_organization(year,regional_organization_id) 
    lv = RegionalOrganization.find(regional_organization_id)
    ids = lv.orchestras.pluck(:id)

    ReportSheet.includes(:orchestra).where("orchestra_id in (?) and year=?", ids,year)
  end


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

		if self.uv.nil? then 
      self.uv=false 
    else 
      logger.debug "UV was not nil" 
    end

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

		if (orchestra.is_coop? )
        then
           return Prices.coopRate
    elsif orchestra.is_foreign_coop?
      return Prices.foreignCoopRate
		elsif orchestra.is_lorch? 
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
		if orchestra.is_lorch? then
			return youth+teens+adult+senior
		else
			return youth+teens+adult+senior+azubi
		end
	end

	def calcGemaCount
		# TODO: need a clean solution for the double members
		if orchestra.is_lorch? then
			return youth+teens+adult+senior-azubi
		else
			return youth+teens+adult+senior
		end
	end

	def calcUvCount
		if (uv and not orchestra.is_coop? ) 
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
		return calcBeitrag*BDZ_SETTINGS['tariff']['lvPart']
	end

	def calcZeitungen
		if (orchestra.is_lorch? ) then
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
    if report_date.nil? then
      return false 
    else 
      return report_date >= Date.new(year,3,1)
    end
  end

  def gen_invoice
    @invoice = Invoice.new
    @invoice.invoice_type = "beitragsrechnung"
    @invoice.invoice_date = Time.now
    @invoice.number = "#{orchestra.member.mglnr}-BEITRAG#{year}"
    @invoice.customer = orchestra.to_customer

		if ( orchestra.is_coop? ) then
			@invoice.addItem(1,Prices.lvOrchRate,'Beitrag kooperativ')
		elsif (orchestra.is_lorch? ) then
			@invoice.addItem(1,Prices.lvOrchRate,'Landesorchesterbeitrag')
			count = calcGemaCount
			if ( count > 0 ) then
				@invoice.addItem(count,Prices.lvMember,'GEMA+Haftpflichtbeitrag je Mitglied')
			end
		else
			if ( isMinTariff? or isMaxTariff? ) then
				@invoice.addItem(children,0, 'Beitrag Kinder')
				@invoice.addItem(teens,0, 'Beitrag Jugendliche 15-18')
				@invoice.addItem(youth,0, 'Beitrag Erwachsene 19-27')
				@invoice.addItem(adult,0, 'Beitrag Erwachsene')
				@invoice.addItem(senior,0, 'Beitrag Erwachsene 55+')
			else
				@invoice.addItem(children,Prices.childrenRate, 'Beitrag Kinder')
				@invoice.addItem(teens,Prices.teensRate, 'Beitrag Jugendliche 15-18')
				@invoice.addItem(youth,Prices.youthRate, 'Beitrag Erwachsene 19-27')
				@invoice.addItem(adult,Prices.adultRate, 'Beitrag Erwachsene')
				@invoice.addItem(senior,Prices.seniorRate, 'Beitrag Erwachsene 55+')
			end

			if ( isMinTariff? ) then
				@invoice.addItem(1,Prices.minTariff,'Mindestbeitrag')
			elsif ( isMaxTariff? ) 
				@invoice.addItem(1,Prices.maxTariff,'H{"o}chstbeitrag')
			end
		end

		if ( uv ) then
			@invoice.addItem(calcUvCount,Prices.uvRate, 'Unfallversicherung')
		end

    if ( delayed? ) then
      @invoice.addItem(1,Prices.delayFee, I18n.t('report_sheet.delay_fee'))
    end

    @invoice
  end

  def total_ensembles
    sum=0;
    data = [ child_ens,youth_ens,adult_ens,senior_ens,chamber_ens]

    data.compact.sum
  end


  def ens_key_string
    data = [ child_ens,youth_ens,adult_ens,senior_ens,chamber_ens]
    data.map! { |x| x.to_i }
    "|"+data.join("|")+"|"

  end

  def update_stats(hash, key, value)
    hash[key]+= value unless value.nil?
  end

  def self.renderOds(report_sheets,filename)
	  RODF::Spreadsheet.file(filename) do
      table "Meldebögen"  do
        row {
          cell I18n.t("member.mglnr")
          cell I18n.t("common.year")
          cell I18n.t("helpers.label.report_sheet.children")
          cell I18n.t("helpers.label.report_sheet.teens")
          cell I18n.t("helpers.label.report_sheet.youth")
          cell I18n.t("helpers.label.report_sheet.adult")
          cell I18n.t("helpers.label.report_sheet.senior")
          cell I18n.t("helpers.label.report_sheet.uv")
          cell I18n.t("helpers.label.report_sheet.zusatz_uv")
          cell I18n.t("helpers.label.report_sheet.gema")
          cell I18n.t("helpers.label.report_sheet.azubi")
          cell I18n.t("helpers.label.report_sheet.passive")
          cell I18n.t("helpers.label.report_sheet.child_ens")
          cell I18n.t("helpers.label.report_sheet.youth_ens")
          cell I18n.t("helpers.label.report_sheet.adult_ens")
          cell I18n.t("helpers.label.report_sheet.senior_ens")
          cell I18n.t("helpers.label.report_sheet.chamber_ens")
          cell I18n.t("helpers.label.report_sheet.other_ens")
          cell I18n.t("helpers.label.report_sheet.azubi_child")
          cell I18n.t("helpers.label.report_sheet.azubi_teens")
          cell I18n.t("helpers.label.report_sheet.azubi_youth")
          cell I18n.t("helpers.label.report_sheet.azubi_adult")
          cell I18n.t("helpers.label.report_sheet.azubi_senior")
          cell I18n.t("helpers.label.report_sheet.supporters")
          cell I18n.t("helpers.label.report_sheet.zo")
          cell I18n.t("helpers.label.report_sheet.zi_o")
          cell I18n.t("helpers.label.report_sheet.go")
          cell I18n.t("helpers.label.report_sheet.oz")
        }

        report_sheets.each do |rs|
          row {
            cell rs.orchestra.member.mglnr
            cell rs.year
            cell rs.children
            cell rs.teens
            cell rs.youth
            cell rs.adult
            cell rs.senior
            cell rs.uv
            cell rs.zusatz_uv
            cell rs.gema
            cell rs.azubi
            cell rs.passive
            cell rs.child_ens
            cell rs.youth_ens
            cell rs.adult_ens
            cell rs.senior_ens
            cell rs.chamber_ens
            cell rs.other_ens
            cell rs.azubi_child
            cell rs.azubi_teens
            cell rs.azubi_youth
            cell rs.azubi_adult
            cell rs.azubi_senior
            cell rs.supporters
            cell rs.zo
            cell rs.zi_o
            cell rs.go
            cell rs.oz
          }
        end
      end
    end
  end


#	TODO: def scoped for easier retrieval!
#   def orchestras 
#    Orchestra.scoped(:joins => {:user => :memberships}, :conditions => { :memberships => { :group_id => id } })
#   end
end
