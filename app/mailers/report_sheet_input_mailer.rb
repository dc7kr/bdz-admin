class ReportSheetInputMailer < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(rsi,rs_year, attach_file, attach_data)
	@rsi = rsi
	@year = @rsi.report_sheet.year.to_s
    @orchestra = rsi.orchestra

	@salutation = t('common.salutation_full.'+@orchestra.anrede)

	@url = BDZ_SETTINGS['meldebogen_url']

	if (@orchestra.is_lorch? ) then
		@mb_url = BDZ_SETTINGS['mb_form_url_l']
	else
		@mb_url = BDZ_SETTINGS['mb_form_url_v']
	end

	@from = BDZ_SETTINGS['contacts']['gs']

	attachments[attach_file] = attach_data

	mail(:to => @orchestra.email, :subject => "Mitgliedermeldung "+@year)
  end
end
