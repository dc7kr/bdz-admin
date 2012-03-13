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
	return orchName.gsub("'","")
  end
end
