class ReportSheetInput < ActiveRecord::Base
  belongs_to :report_sheet
  belongs_to :orchestra

  def self.new_for_orchestra(orchestra,year)

    @report_sheet_input = ReportSheetInput.new

    pass_chars = ('0'..'9').to_a
    pass_chars+= ('A'..'Z').to_a
    pass_chars+= ('a'..'z').to_a
	@report_sheet_input.token = pass_chars.shuffle.first(12).join
	@report_sheet_input.orchestra = orchestra
	@report_sheet = ReportSheet.for_year(year)
	@report_sheet_input.report_sheet = @report_sheet

	@report_sheet_input
  end

end
