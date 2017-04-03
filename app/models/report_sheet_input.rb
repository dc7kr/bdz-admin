class ReportSheetInput < ActiveRecord::Base
  belongs_to :report_sheet
  belongs_to :orchestra

  validates :report_sheet, presence: true

  scope :not_final, ->{ includes(:report_sheet).where("report_sheets.orchestra_id is null") }

  def self.new_for_orchestra(orchestra,year)

    @report_sheet_input = ReportSheetInput.new

    pass_chars = ('0'..'9').to_a
    pass_chars+= ('A'..'Z').to_a
    pass_chars+= ('a'..'z').to_a

	  @report_sheet_input.token = pass_chars.shuffle.first(12).join
	  @report_sheet_input.orchestra = orchestra
	  @report_sheet = ReportSheet.new_for_year(year)
	  @report_sheet_input.report_sheet = @report_sheet

	  @report_sheet_input
  end

  def self.for_year(year)
	includes(:report_sheet,:orchestra).where('report_sheets.year = :year', :year=>year).first
  end

  def self.for_orchestra_and_year(orchestra,year)
	  joins(:report_sheet).where('report_sheet_inputs.orchestra_id = :orchestra_id and report_sheets.year = :year',:orchestra_id=>orchestra.id, :year=>year).first
  end

end
