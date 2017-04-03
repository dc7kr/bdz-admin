class ReportSheetInputMailer < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(recipient, personalized_file, attachment_file, params) 

    @rsi = params[:rsi]
    @year = @rsi.report_sheet.year.to_s

    @orchestra = @rsi.orchestra
    member = @orchestra.member

    @salutation = t('common.salutation_full.'+member.anrede)

    @url = BDZ_SETTINGS['meldebogen_url']

    if (@orchestra.is_lorch? ) then
      @mb_url = BDZ_SETTINGS['mb_form_url_l']
    else
      @mb_url = BDZ_SETTINGS['mb_form_url_v']
    end

	  @from = BDZ_SETTINGS['contacts']['gs']

    storage_dir = BDZ_SETTINGS["invoice_archive_dir"]

    if (personalized_file != nil ) then
      attachment_data = File.new(personalized_file.full_path).read
		  attachments[personalized_file.orig_filename ] = attachment_data
    end

   	mail(:to => recipient, :subject => "Mitgliedermeldung "+@year)
  end
end
