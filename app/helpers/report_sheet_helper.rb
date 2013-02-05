module ReportSheetHelper

  def triggers_warning?(last,cur) 

	if last.calcGemaCount == 0 or cur.calcGemaCount == 0 then
		return true
	end

	fract = (cur.calcGemaCount - last.calcGemaCount)*1.0/last.calcGemaCount 
	Rails.logger.info(last.calcGemaCount.to_s+" cur: "+cur.calcGemaCount.to_s+" fract: "+fract.abs.to_s)
	if fract.abs >BDZ_SETTINGS['report_sheet']['threshold'] then
		true
	else
		false
	end
  end
end
