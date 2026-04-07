class ReportSheetInput < ApplicationRecord
  belongs_to :report_sheet
  belongs_to :orchestra

  scope :not_final, -> { includes(:report_sheet).where(report_sheets: { orchestra_id: nil }) }

  def self.new_for_orchestra(orchestra, year)
    @report_sheet_input = ReportSheetInput.new

    pass_chars = ("0".."9").to_a
    pass_chars += ("A".."Z").to_a
    pass_chars += ("a".."z").to_a

    pass_chars.delete("I")
    pass_chars.delete("1")
    pass_chars.delete("l")
    pass_chars.delete("0")
    pass_chars.delete("O")

    @report_sheet_input.token = pass_chars.sample(12).join
    @report_sheet_input.orchestra = orchestra
    @report_sheet = ReportSheet.new_for_year(year)
    @report_sheet_input.report_sheet = @report_sheet

    @report_sheet_input
  end

  def self.for_year(year)
    includes(:report_sheet, :orchestra).where(report_sheets: { year: year })
  end

  def self.for_orchestra_and_year(orchestra, year)
    joins(:report_sheet).where("report_sheet_inputs.orchestra_id = :orchestra_id and report_sheets.year = :year",
                               orchestra_id: orchestra.id, year: year).first
  end

  def populate_from_last_year
      last_rs = ReportSheet.find_by(orchestra_id: self.orchestra_id, year: report_sheet.year-1)

      if not last_rs.present?
        Rails.logger.warn("No report sheet for year #{report_sheet.year-1} and member #{orchestra.member.mglnr}")
        return false
      end

      Rails.logger.debug(last_rs.year)
      report_sheet.populate_from(last_rs)
      report_sheet.reminder_level = 2
      report_sheet.orchestra = self.orchestra

      if report_sheet.save
        report_sheet
      else
        Rails.logger.warning("Could not save: #{report_sheet.errors}")
        nil
      end
  end
end
