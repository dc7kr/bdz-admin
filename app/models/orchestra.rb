require 'valid_email'
class Orchestra < ApplicationRecord
  include Authority::Abilities

  acts_as_paranoid

  has_one :member, as: :member_entity
  has_many :report_sheets
  has_many :orchestra_contacts
  has_many :orchestra_members

  accepts_nested_attributes_for :member

  validates_presence_of :orchName

  scope :cancelled, -> {
    joins(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < now()") 
  }

  scope :member_next_year, -> {
    joins(:member).where("members.austritt_zum is null or members.austritt_zum = '0000-00-00' or year(members.austritt_zum) > year(now())") 
  }

  scope :nomail, -> {
    joins(:member).where("members.email is null or members.email=''").order("members.mglnr")
  }

  scope :mail, -> {
    joins(:member).where("members.email is not null and members.email <>''")
  }

  scope :regular, -> { where("orch_type <> ? ","X") }
  scope :regional, -> { where("orch_type = 'L' ") }  

  scope :no_report_sheet, ->(year) { includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.id AND report_sheets.year='+String(year)).where(['report_sheets.id IS NULL AND orchestras.orch_type in ( "L","O")']) }

  def self.no_payment(before=nil,lv=nil)
    data = MemberAccountBooking.unbalanced_before_year(before,lv)

    ids = data[:ids]
    accounts = data[:accounts]

    members = Member.includes(:member_entity).where("member_entity_type='Orchestra' and id in (?)",ids.to_a).order(:mglnr)

    h = Hash.new

    h[:members]=members
    h[:accounts]=accounts

    h
  end

  def self.for_mglnr(mglnr) 
    member = Member.where("mglnr = ?",mglnr).take

    if member.nil? or not member.member_entity.is_a?(Orchestra) then
      nil
    else
      member.member_entity
    end
  end

  #inherits_from :member

  #validates :mglnr, :orch_mglnr => true

  def self.notinvoiced(year)
    joins([:report_sheets,:member]).joins("LEFT JOIN member_account_bookings mb ON members.id=mb.member_id AND mb.booking_type='B' and mb.booking_year = #{year}").where("mb.id IS NULL and report_sheets.year= ?",year).order("members.mglnr")
  end

  def self.mailForEvent(event,via_paper)
    if (via_paper) then
			joins([:member]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = orchestras.id AND members.member_entity_type='Orchestra' AND e.event_id='"+event+"'").where("e.id IS NULL")
    else
			joins([:member]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = orchestras.id AND members.member_entity_type='Orchestra' AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
    end
  end

  def self.mail
    Member.mail(Orchestra)
  end

  def self.search(search)
	if (search)
		where('members.mglnr = ? or orchestras.orchName like ? or members.email like ?',"#{search}","%#{search}%","%#{search}%");
	else
		where('1') 
	end
  end

  def cleanOrchName
	return orchName.gsub("'","").gsub(';','\n')
  end

  def inlineFullAddress
	"#{fullname}, #{inlineAddress}"
  end

  def inlineAddress
	"#{member.strasse}, #{member.plz} #{member.ort}"
  end

  def lastReportSheet
	  @reportSheets = ReportSheet.where('orchestra_id = ?',id).order("year desc")
	  return @reportSheets[0]
  end

  def report_sheet_for_year(year)
    if year.nil? then
      year=Time.now.year
    end

    rs = report_sheets.where(:year => year)

    if rs then
      rs.first
    else
      nil
    end
  end

  def currentMagazines
	  if is_coop?
		  return BDZ_SETTINGS["tariff"]["koopZtgCount"].to_i
	  end

	  if ( currentReportSheet ) 
		  return currentReportSheet.calcZeitungen
	  elsif lastReportSheet.nil? 
      Rails.logger.info("No reportsheet for orchestra : "+member.mglnr.to_s)
      return 0
    else
	   return lastReportSheet.calcZeitungen	
    end
  end

  def gema(year=nil)
    rs = report_sheet_for_year(year)
    if ( rs ) 
        return rs.calcGemaCount
    end
  end

  def total(year=nil)
    rs = report_sheet_for_year(year)

	  if ( rs ) 
	    return rs.totalActiveMembers
	  end
  end

  def lv_share(year=nil)  
    rs = report_sheet_for_year(year)
    if ( rs ) then
      return rs.calcLvPart
    end
  end

  def age_key_str(year)
    rs = report_sheet_for_year(year) 
    str = ""
    if ( rs ) then
      str=rs.ageKeyStr
    else 
     str=" kein Meldebogen"
    end

    str
  end

  def currentLvRate
    if ( currentReportSheet ) then
      return currentReportSheet.lvRate
    end
  end

  def sheet_for_year(year) 
    report_sheets.each do |sheet|
      if sheet.year == year then
        return sheet
      end
    end
    return nil
  end

  def currentReportSheet
    #	ReportSheet.scoped(:conditions=> { :year => @currentYear })
    # TODO:
    currentYear = Time.new.year
    report_sheets.each do |sheet|
      if (sheet.year == currentYear) then
        return sheet
      end
    end
    return nil
  end

  comma :minimal do
	  mglnr 'Mitgliedsnummer'
    orchName 'Orchestername'
	  inlineFullAddress 'Adresse'
  end

  # CSV
  comma :gema do
	  member.mglnr 'Mitgliedsnummer'
	  orchName  'Orchestername'
    inlineFullAddress 'Adresse'
    gema 'Mitglieder'
  end

  comma :magazine do
	  currentMagazines 'Zeitungen'
	  cleanOrchName
	  fullname
    strasse
    plz
    ort
	  letterCountry
  end
  
  comma :lv do
	  member.mglnr
	  cleanOrchName
	  fullname
	  member.strasse
	  member.plz
	  member.ort
	  member.email
  end

  def letterCountry
	  member.letterCountry
  end

  def countryCode
	  member.countryCode
  end

  def fullname
	  if ( member.anrede != nil && member.anrede.length > 0 ) then
		  I18n.t("common.salutation_d."+member.anrede)+" "+member.fullname
	  else
		  member.fullname
	  end
  end

  def address
    orchName+", "+member.address
  end

  def address_block
	  orchName+"\n"+member.address_block
  end

  def is_coop?
	  orch_type == 'K'
  end

  def is_foreign_coop?
    orch_type == 'A'
  end

  def is_lorch?
	  orch_type == 'L'
  end

  def is_regular?
	  orch_type == 'O'
  end

  def is_direct_debit?
    member.is_direct_debit?
  end

  def has_notify_event?(event_id)
	  member.has_event?(['E','L'],event_id)
  end

  def iban
    member.iban
  end

  def mref
    member.mref
  end

  def has_event?(event_type,event_id)
	  member.has_event?(event_type,event_id)
  end

  def zero_member_fee_balance?
    booking_sum = MemberAccountBooking.where("member_id = ? and booking_type in ('B','A','L')",member.id).sum(:amount)

    return booking_sum >-0.1
  end


  def self.with_zero_balance
    ids = Member.ids_with_non_zero_balance(Orchestra)

    # nasty workaround for ActiveRecord bug (KR 24.2.20)
    if (ids.size ==0 ) then
  	  Orchestra.includes(:report_sheets).joins(:member)
    else
  	  Orchestra.includes(:report_sheets).joins(:member).where("NOT (members.id  in (?) )",ids)
    end
  end

  #for address interface
  def company
    orchName
  end

  def street
    member.strasse
  end
  def zip
    plz
  end
  def city
    ort
  end

  def mandate_id
    member.mandate_id
  end

  def account_owner
    orchName
  end

  def has_email? 
    member.has_email?
  end

  def sig_date
    member.sig_date
  end

  def to_addressee
    addressee = member.to_addressee

    addressee.company      = orchName
    addressee.name         = fullname
    addressee.entity       = self
    addressee.event_class = self.event_class

    addressee
  end

  def to_customer
    cust = member.to_customer
    cust.entity = self

    cust.company = orchName
    cust.account_owner = orchName

    cust
  end

  # for member event handling

  def get_unbalanced_bookings
    member.get_unbalanced_bookings
  end

  def self.for_user(user)
    if (not user.is_restricted_role?) then
      return where(1)
    end

    restr = user.restricting_entity

    if restr.nil? then
      Rails.logger.warning("User "+current_user.email+" has no restriction entity configured - SAFETY NET!")
      return where ("1=0") 
      # safety net
    end

    if restr.class == RegionalOrganization then
      where("members.regional_organization_id = ?",restr.id)
    elsif restr.class == Orchestra then
      where("id = ?", restr.id)
    elsif restr.class == PersonMember then
      where("1=0")
    end
  end

  def contacts_by_role
    result = Hash.new
    orchestra_contacts.each do |oc|
      result[oc.role]= oc
    end
    result
  end

  def event_class
    MemberEvent
  end

  def contact_info
    member.contact_info
  end
  
  def last_invoice
    member.last_invoice
  end

  def to_s
    orchName
  end 

  def full_url
    if url.start_with?("http")
      url
    else
      "http://"+url
    end
  end

  def get_member_fee_booking(year)
    MemberAccountBooking.where("member_id = :member_id AND booking_type='B' AND mb.booking_year = :booking_year", :member_id => member.id, :booking_year => :year)
  end

  def check_double
    result = Hash.new

    result[:faulty] = Array.new
    result[:verified] = Array.new
    result[:neutral] = Array.new

    self.orchestra_members.each do |o|
      if o.mglnr != nil and o.mglnr != 0 and o.mglnr != self.member.mglnr then
        orch = Orchestra.joins(:member).where("members.mglnr = ?",o.mglnr)	

        if (orch != nil and orch[0] != nil ) then
          Rails.logger.info("Found orchestra")
          matching = OrchestraMember.where("orchestra_id = ? and first_name like ? and last_name like ?",orch[0].id,o.first_name,o.last_name).first

          if ( matching != nil  ) then 
            other_orch = matching.orchestra

            if other_orch.is_coop? or other_orch.is_lorch? then
              result[:faulty] << o 
            else
              result[:verified] << o
            end
          else 
            result[:faulty] << o
          end
        else
          Rails.logger.info("Invalid mglnr: "+o.mglnr.to_s)
          result[:faulty] << o
        end
      else 
        result[:neutral] << o
      end
	  end

    result
  end

  def report_sheet_required?
    self.orch_type != "X"
  end


  def has_faulty_double_members?
    result = check_double

    result[:faulty].count != 0
  end

  def gen_rsi(rs_year)

    rsi = ReportSheetInput.for_orchestra_and_year(self,rs_year)

    if not rsi.nil? then
      logger.warn("Report sheet already exists for %s",rs_year.to_s)
      return rsi
    end

    rsi = ReportSheetInput.new_for_orchestra(self,rs_year)
        
    if rsi.report_sheet.save then
      rsi.save
    else 
      logger.warn(rsi.report_sheet.errors.full_messages.join("\n"))
      logger.warn("Something went wrong during save of report sheet!")
    end
  end
end
