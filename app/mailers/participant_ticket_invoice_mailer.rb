class ParticipantTicketInvoiceMailer < ApplicationMailer

  def notification(festival_application_token)
    @appl = FestivalApplication.find_by token: festival_application_token

    @invoice = @appl.get_ticket_invoice

    festival_year = BDZ_SETTINGS["config"]["festival_year"]

    to = email_address_with_name(@invoice.customer.email, @invoice.customer.full_name)
    from = contact_email_with_name("festival_gs")
    bcc = INVOICE_CONFIG.invoice_out_bcc

    locale = @invoice.locale

    pdf_file = @invoice.get_invoice_file

    @pickup_date = DateTime.parse(BDZ_SETTINGS["config"]["pickup_date"]).strftime("%d.%m.%Y %H:%M")

    attachments[pdf_file.visible_filename] = File.read(pdf_file.full_path)

    I18n.with_locale(locale) do
      mail(subject: default_i18n_subject(participant_id: @appl.id, invoice_nr: @invoice.full_number, festival_year: festival_year), to: to, from: from, bcc: bcc)
    end
  end
end
