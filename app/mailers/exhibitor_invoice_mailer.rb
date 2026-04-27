class ExhibitorInvoiceMailer < ApplicationMailer
  def customer_mail(invoice_id)
    @invoice = CorikaInvoices::Invoice.find(invoice_id)

    cust = @invoice.customer

    @festival_year = BDZ_SETTINGS["config"]["festival_year"]

    to = email_address_with_name(cust.email, cust.full_name)
    from = contact_email_with_name("festival_gs")
    bcc = INVOICE_CONFIG.invoice_out_bcc

    pdf_file = @invoice.get_invoice_file
    locale = @invoice.locale

    attachments[pdf_file.visible_filename] = File.read(pdf_file.full_path)

    I18n.with_locale(locale) do
      mail(subject: default_i18n_subject(festival_year: @festival_year, invoice_number: @invoice.seq_nr), to: to, from: from, bcc: bcc)
    end
  end

  def admin_mail(to, generator_session_id)

    @generator_session_id = generator_session_id

    festival_year = BDZ_SETTINGS["config"]["festival_year"]
    from = contact_email_with_name("system")
    subject = default_i18n_subject(festival_year: festival_year)

    I18n.with_locale("de") do
      mail(subject: subject, to: to, from: from)
    end
  end
end
