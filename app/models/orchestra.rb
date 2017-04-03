require 'valid_email'
class Orchestra < ActiveRecord::Base
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

  scope :regional, -> { where("orch_type = 'L' ") }  

  scope :no_report_sheet, ->(year) { includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.id AND report_sheets.year='+String(year)).where(['report_sheets.id IS NULL']) }

  def self.no_payment(before=nil)
    data = MemberAccountBooking.unbalanced_before(before)

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

  #has_many :current_report_sheet, :class_name => 'ReportSheet', :where => ['year = ?',Time.now.year]

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
  def self.nomail
    Member.nomail(Orchestra)
  end

  def self.search(search)
	if (search)
		where('members.mglnr = ? or orchestras.orchName like ?',"#{search}","%#{search}%");
	else
		where(1) 
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
	  if ( orch_type=='K') then
		  return 2;
	  end

	  if ( currentReportSheet ) then
		  return currentReportSheet.calcZeitungen
	  else 
		  return lastReportSheet.calcZeitungen	
	  end
  end

  def gema(year=nil)
    rs = report_sheet_for_year(year)
    if ( rs ) then 
        return rs.calcGemaCount
    end
  end

  def total(year=nil)
    rs = report_sheet_for_year(year)

	  if ( rs ) then 
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
	  Orchestra.includes(:report_sheets).joins(:member).where("NOT (members.id  in (?) )",ids)
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
end
