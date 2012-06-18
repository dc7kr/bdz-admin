require 'valid_email'
class Orchestra < ActiveRecord::Base
  has_many :report_sheets
  #has_many :current_report_sheet, :class_name => 'ReportSheet', :where => ['year = ?',Time.now.year]

  inherits_from :member

  validates :mglnr, :orch_mglnr => true

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
    currentYear = Time.new.year
    report_sheets.each do |sheet|
      if (sheet.year == currentYear) then
        return sheet
      end
    end
    return nil
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

  def letterCountry
	member.letterCountry
  end
  def countryCode
	member.countryCode
  end
  def fullname
	member.fullname
  end
  def address
    fullname + ", " +strasse + ", "+plz+ " "+ort
  end

end
