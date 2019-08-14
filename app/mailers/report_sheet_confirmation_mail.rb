class ReportSheetConfirmationMail < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(recipient, personalized_file, attachment_file, params) 

    @rsi = params[:rsi]
    @year = @rsi.report_sheet.year.to_s

    @orchestra = @rsi.orchestra

    @salutation = t('common.salutation_full.'+@orchestra.member.anrede)

    if (personalized_file != nil ) then
      attachment_data = File.new(personalized_file.full_path).read
		  attachments[personalized_file.orig_filename ] = attachment_data
    end

   	mail(:to => recipient, :subject => "Meldebogen #{@year} erfolgreich eingereicht.")
  end
end
