require 'valid_email'
class Orchestra < ActiveRecord::Base

  scope :cancelled, includes(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < now()")

  has_many :report_sheets
  has_many :orchestra_contacts
  has_many :orchestra_members
  #has_many :current_report_sheet, :class_name => 'ReportSheet', :where => ['year = ?',Time.now.year]

  inherits_from :member

  validates :mglnr, :orch_mglnr => true

  def self.mailForEvent(event)
			includes([:member]).joins("LEFT JOIN member_events e ON orchestras.member_id=e.member_id AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
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

  def has_event?(event_type,event_id)
	member.has_event?(event_type,event_id)
  end
end
