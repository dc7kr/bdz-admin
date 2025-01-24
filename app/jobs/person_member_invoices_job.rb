class PersonMemberInvoicesJob < BaseInvoicesJob
  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject

  def perform(year = nil, user_id = nil)
    year = Time.now.year if year.nil?

    init_fields(year, user_id)
    letters = []

    person_members = PersonMember.notinvoiced(year)

    if person_members.length == 0
      logger.info('No pending invoices. PersonMemberInvoiceJob done.')
      return
    end

    mailing_tool = MailingTool.new(year, 'gs', "RECHNUNG#{year}", "Beitragsrechnung #{year}")

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

    if letters.size > 0

      pdf_filename = "#{date_prefix}-em-beitragsrechnungen.pdf"

      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
      self.archive_tool.merge_pdfs(letters, pdf_merged_file)
    end

    ddFile = self.sepa_writer.generate_file

    send_mail(ddFile, pdf_merged_file, triggered_by)
  end

  def person_member_invoice(person, year)
    invoice = person.gen_invoice(year)
    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(self.tex_writer)

    if invoice_file.nil?
      logger.error("Could not generate invoice: #{person.member.mglnr}")
      return nil
    end

    booking_txt = 'Beitrag ' + person.tariff.description + ' ' + String(year)

    person.member.create_invoice_booking(year, invoice, invoice_file.orig_filename, booking_txt)
    person.member.create_dd_booking(self.sepa_writer, invoice, year)

    invoice_file
  end
end
