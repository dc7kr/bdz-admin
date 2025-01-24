require 'fileutils'

class OrchestraInvoicesJob < BaseInvoicesJob
  queue_as :default

  include BulkMailHelper
  include Rails.application.routes.url_helpers

  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject

  # sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def perform(year = Time.now.year, user_id = nil)

    init_fields(year, user_id)
    letters = []

    @orchestras = Orchestra.notinvoiced(year)

    if @orchestras.length == 0
      logger.info('No pending invoices. OrchestraInvoiceJob done,')
      return
    end

    tool = MailingTool.new(year, 'gs', "RECHNUNG#{year}", "Beitragsrechnung #{year}")

    @orchestras.each do |orch|
      mglnr = orch.member.mglnr

      Rails.logger.debug { "Generate invoice for: #{mglnr}" }
      invoice_file = orchestraInvoice(orch, year)

      if invoice_file.nil?
        logger.error("No invoice generated for mglnr: #{mglnr}")
      else
        logger.debug("PDF File archived as #{invoice_file}")

        add_mailer_params = { year: year, mglnr: mglnr }

        tool.deliver_mailing(InvoiceMail, orch.to_addressee, invoice_file, nil, letters, add_mailer_params)
      end
    end

    pdf_merged_file = nil

    if letters.size > 0
      pdf_filename = "#{date_prefix}-orch-beitragsrechnungen.pdf"

      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
      self.archive_tool.merge_pdfs(letters, pdf_merged_file)
    end

    ddFile = self.sepa_writer.generate_file

    send_mail(ddFile, pdf_merged_file, triggered_by)
  end

  def orchestraInvoice(orch, year)
    invoice = orch.gen_invoice(year)

    return if invoice.nil?

    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(tex_writer)

    return nil if invoice_file.nil?

    booking_txt = 'Beitrag ' + String(year)
    orch.member.create_invoice_booking(year, invoice, invoice_file.orig_filename, booking_txt)
    orch.member.create_dd_booking(self.sepa_writer, invoice, year)

    invoice_file
  end
end
