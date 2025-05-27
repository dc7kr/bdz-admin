module ReportSheetHelper
  def triggers_warning?(last, cur)
    return true if last.calcGemaCount.zero? || cur.calcGemaCount.zero?

    fract = (cur.calcGemaCount - last.calcGemaCount) * 1.0 / last.calcGemaCount
    Rails.logger.info("#{last.calcGemaCount} cur: #{cur.calcGemaCount} fract: #{fract.abs}")
    fract.abs > BDZ_SETTINGS["report_sheet"]["threshold"]
  end
end
