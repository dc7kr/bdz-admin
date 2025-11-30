class FestivalInvoiceMail < ApplicationMailer
  def notify(recipient, personalized_file_hash, _attachment_file, params)
    subject = params[:subject]

    @inv = CorikaInvoices::Invoice.find(params[:invoice_id])

    personalized_file = CorikaInvoices::ArchiveFile.from_hash(personalized_file_hash)

    locale = params[:locale]

    bdz_contact = BDZ_SETTINGS["contacts"]["festival"]

    locale = :de if locale.nil?

    unless personalized_file.nil?
      attachment_data = File.new(personalized_file.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    I18n.with_locale(locale) do
      mail(from: @inv.contact.email, to: recipient, subject: subject, cc: params[:cc], bcc: params[:bcc])
    end
  end
end
