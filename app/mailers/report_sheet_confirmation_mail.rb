class ReportSheetConfirmationMailMailer < ApplicationMailer
  default from: 'geschaeftsstelle@zupfmusiker.de'

  def notify(recipient, personalized_file_hash, _attachment_file, params)
    @rsi = params[:rsi]
    @year = @rsi.report_sheet.year.to_s

    @orchestra = @rsi.orchestra

    personalized_file = MailingFile.from_hash(personalized_file_hash)

    @salutation = t("common.salutation_full.#{@orchestra.member.anrede}")

    unless personalized_file.nil?
      attachment_data = File.new(personalized_file.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    mail(to: recipient, subject: "Meldebogen #{@year} erfolgreich eingereicht.")
  end
end
