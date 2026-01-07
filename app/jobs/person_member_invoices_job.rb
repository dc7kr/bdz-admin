class PersonMemberInvoicesJob < BaseInvoicesJob
  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject,
                  retry: false

  def perform(year = nil, user_id = nil)
    year = Time.zone.now.year if year.nil?

    init_fields(year, user_id)
    letters = []

    person_members = PersonMember.notinvoiced(year)

    if person_members.empty?
      logger.info("No pending invoices. PersonMemberInvoiceJob done.")
      return
    end

    mailing_tool = MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

    person_members.each do |pm|
      mglnr = pm.member.mglnr

      logger.debug("Gen invoice for: #{pm.member.mglnr}")
      invoice_file = person_member_invoice(pm, year)

      if invoice_file.nil?
        logger.info("No invoice generated for: #{mglnr} tariff: #{pm.tariff.description}")
        next
      end

      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { year: year, mglnr: mglnr }

      mailing_tool.deliver_mailing(InvoiceMail, pm.to_addressee, invoice_file, nil, letters, add_mailer_params)
    end

    pdf_merged_file = nil

    if letters.size.positive?

      pdf_filename = "#{date_prefix}-em-beitragsrechnungen.pdf"

      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
      archive_tool.merge_pdfs(letters, pdf_merged_file)
    end

    ddFile = sepa_writer.generate_file

    send_mail(ddFile, pdf_merged_file)
  end

  def person_member_invoice(person, year)
    invoice = person.gen_invoice(year)
    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf

    if invoice_file.nil?
      logger.error("Could not generate invoice: #{person.member.mglnr}")
      return nil
    end

    booking_txt = "Beitrag #{person.tariff.description} #{String(year)}"

    person.member.create_invoice_booking(year, invoice, invoice_file.orig_filename, booking_txt)
    person.member.create_dd_booking(sepa_writer, invoice, year)

    invoice_file
  end
end
