class ReportSheetInputMailer < ApplicationMailer
  def notify(recipient, personalized_hash, _attachment_hash, params)
    # the MailingFiles are serialized here so we need to deserialize from hash first

    personalized_file = MailingFile.from_hash(personalized_hash)
    MailingFile.from_hash(personalized_hash)

    @rsi = params[:rsi]
    @year = @rsi.report_sheet.year.to_s

    @orchestra = @rsi.orchestra
    member = @orchestra.member

    @salutation = t("common.salutation_full.#{member.anrede}")

    @url = BDZ_SETTINGS["meldebogen_url"]

    @mb_url = if @orchestra.is_lorch?
                BDZ_SETTINGS["mb_form_url_l"]
    else
                BDZ_SETTINGS["mb_form_url_v"]
    end

    @from = BDZ_SETTINGS["contacts"]["gs"]

    DOCS_CONFIG.archive_dir

    unless personalized_file.nil?
      attachment_data = File.new(personalized_file.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    mail(from: report_sheet_from, to: recipient, subject: "Mitgliedermeldung #{@year}")
  end
end
