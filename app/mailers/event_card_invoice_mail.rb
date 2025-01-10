class EventCardInvoiceMail < ApplicationMailer
  def notify(recipient, personalized_file, _attachment_file, params)
    subject = params[:subject]

    @inv = params[:invoice]
    locale = params[:locale]

    bdz_contact = BDZ_SETTINGS['contacts']['festival']

    @iban = bdz_contact['iban']
    @bic = bdz_contact['bic']
    @bank = bdz_contact['bank']

    locale = :de if locale.nil?

    unless personalized_file.nil?
      attachment_data = File.new(personalized_file.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    I18n.with_locale(locale) do
      mail(to: recipient, subject: subject, cc: params[:cc], bcc: params[:bcc])
    end
  end
end
