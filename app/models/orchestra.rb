require 'valid_email'
class Orchestra < ActiveRecord::Base

  scope :default, includes(:member)
  scope :cancelled, includes(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < now()")

  has_many :report_sheets
  has_many :orchestra_contacts
  has_many :orchestra_members
  #has_many :current_report_sheet, :class_name => 'ReportSheet', :where => ['year = ?',Time.now.year]

  inherits_from :member

  validates :mglnr, :orch_mglnr => true

  def self.mailForEvent(event,via_paper)
    if (via_paper) then
			includes([:member]).joins("LEFT JOIN member_events e ON orchestras.member_id=e.member_id AND e.event_id='"+event+"'").where("e.id IS NULL")
    else
			includes([:member]).joins("LEFT JOIN member_events e ON orchestras.member_id=e.member_id AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
    end
  end

  def self.mail
	  where('members.email IS NOT NULL and length(members.email) >3')
  end
  def self.nomail
	  where('members.email IS NULL or length(members.email) <3')
  end

  def self.search(search)
	if (search)
		where('members.mglnr = ? or orchestras.orchName like ?',"#{search}","%#{search}%");
	else
		scoped
	end
  end

  def cleanOrchName
	return orchName.gsub("'","").gsub(';','\n')
  end

  def inlineFullAddress
	"#{fullname}, #{inlineAddress}"
  end
  def inlineAddress
	"#{strasse}, #{plz} #{ort}"
  end

  def lastReportSheet
	  @reportSheets = ReportSheet.where('orchestra_id = ?',id).order("year desc")
	  return @reportSheets[0]
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

  def currentGema
    if ( currentReportSheet ) then 
        return currentReportSheet.calcGemaCount
    end
  end

  def currentTotal
	  if ( currentReportSheet ) then 
	    return currentReportSheet.totalActiveMembers
	  end
  end

  def currentLvShare  
    if ( currentReportSheet ) then
      return currentReportSheet.calcLvPart
    end
  end

  def currentAgeKeyStr
    str = ""
    if ( currentReportSheet ) then
      str=currentReportSheet.ageKeyStr
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
	  mglnr 'Mitgliedsnummer'
	  orchName  'Orchestername'
    inlineFullAddress 'Adresse'
    currentGema 'Mitglieder'
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
	  mglnr
	  cleanOrchName
	  fullname
	  strasse
	  plz
	  ort
	  email
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

  def t_country(locale=country_code)
    member.t_country(locale)
  end

  def zero_member_fee_balance?
    booking_sum = MemberAccountBooking.where("member_id = ? and booking_type in ('B','A','L')",member.id).sum(:amount)

    return booking_sum >=0
  end


  def self.with_zero_balance
	  accounts = MemberAccountBooking.where("booking_year < year(now())").sum(:amount,:group=>:member_id)

	  ids = Set.new
	  accounts.each do |account|
      if (account[1]<-0.1) then
        ids.add(account[0])
	    end
	  end
	
	  Orchestra.includes([:member,:report_sheets]).where("NOT (member_id  in (?) )",ids)
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

  def to_customer
    cust = member.to_customer
    cust.entity = self

    cust.name= fullname
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
      return scoped
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
end
