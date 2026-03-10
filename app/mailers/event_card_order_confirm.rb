class EventCardOrderConfirm < ApplicationMailer

  def notification(checkout_reference)
    @event_card = EventCard.find_by(checkout_reference: checkout_reference)

    @invoice = @event_card.invoice

    to = email_address_with_name(@event_card.email, @event_card.name)
    from = contact_email_with_name("festival_gs")
    bcc = INVOICE_CONFIG.invoice_out_bcc

    pdf_file = @invoice.get_invoice_file
    locale = @event_card.to_locale

    @pickup_date = DateTime.parse(BDZ_SETTINGS["config"]["pickup_date"]).strftime("%d.%m.%Y %H:%M")

    attachments[pdf_file.visible_filename] = File.read(pdf_file.full_path)

    I18n.with_locale(locale) do
      mail(subject: default_i18n_subject(order_number: @event_card.id), to: to, from: from, bcc: bcc)
    end
  end

  def treasurer(checkout_reference)
    @event_card = EventCard.find_by(checkout_reference: checkout_reference)
    @invoice = @event_card.invoice

    pdf_file = @invoice.get_invoice_file
    sepa_data = @invoice.gen_sepa_xml

    @name = contact_name("treasurer")

    from = contact_email_with_name("system")
    to = contact_email_with_name("treasurer")
    attachments["#{@invoice.number}_sepa.xml"] = sepa_data unless sepa_data.nil?

    mail(subject: default_i18n_subject(order_number: @event_card.id), to: to, from: from)
  end
end
