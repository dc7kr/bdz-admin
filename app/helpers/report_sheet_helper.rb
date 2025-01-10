module ReportSheetHelper
  def triggers_warning?(last, cur)
    return true if last.calcGemaCount == 0 or cur.calcGemaCount == 0

    fract = (cur.calcGemaCount - last.calcGemaCount) * 1.0 / last.calcGemaCount
    Rails.logger.info(last.calcGemaCount.to_s + ' cur: ' + cur.calcGemaCount.to_s + ' fract: ' + fract.abs.to_s)
    fract.abs > BDZ_SETTINGS['report_sheet']['threshold']
  end
end
