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

  def perform(year = Time.zone.now.year, user_id = nil)
    init_fields(year, user_id)
    letters = []

    @orchestras = Orchestra.notinvoiced(year)

    if @orchestras.empty?
      logger.info('No pending invoices. OrchestraInvoiceJob done,')
      return
    end

    tool = MailingTool.new(year, 'gs', "RECHNUNG#{year}", "Beitragsrechnung #{year}")

    delivered = 0
    skipped = 0

    @orchestras.each do |orch|
      mglnr = orch.member.mglnr

      if orch.report_sheet_for_year(year).nil? and orch.report_sheet_required?
        logger.debug("Skipping #{mglnr} - no report sheet")
        skipped += 1
        next
      end

      Rails.logger.debug { "Generate invoice for: #{mglnr}" }
      invoice_file = orchestra_invoice(orch, year)

      if invoice_file.nil?
        logger.error("No invoice generated for mglnr: #{mglnr}")
      else
        logger.debug("PDF File archived as #{invoice_file}")

        add_mailer_params = { year: year, mglnr: mglnr }

        tool.deliver_mailing(InvoiceMail, orch.to_addressee, invoice_file, nil, letters, add_mailer_params)
        delivered += 1
      end
    end

    pdf_merged_file = nil

    if letters.size.positive?
      pdf_filename = "#{date_prefix}-orch-beitragsrechnungen.pdf"

      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
      archive_tool.merge_pdfs(letters, pdf_merged_file)
    end

    if delivered.positive?
      ddFile = sepa_writer.generate_file
      send_mail(ddFile, pdf_merged_file)
    else
      logger.info('No invoices delivered. Not sending notify')
    end
  end

  def orchestra_invoice(orch, year)
    invoice = orch.gen_invoice(year)

    return if invoice.nil?

    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(tex_writer)

    return nil if invoice_file.nil?

    booking_txt = "Beitrag #{String(year)}"
    orch.member.create_invoice_booking(year, invoice, invoice_file.orig_filename, booking_txt)
    orch.member.create_dd_booking(sepa_writer, invoice, year)

    invoice_file
  end
end
