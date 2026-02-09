require "fileutils"

class GenerateOrchestraInvoiceJob < BaseInvoicesJob
  queue_as :default

  include BulkMailHelper
  include Rails.application.routes.url_helpers

  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject,
                  retry: false

  def perform(orchestra_id, year = Time.zone.now.year, user_id = nil)
    init_fields(user_id)

    letters = []

    orchestra = Orchestra.find(orchestra_id)

    if not orchestra.present?
      logger.warn("Orchestra not found. GenerateOrchestraInvoiceJob done.")
      return
    end

    tool = MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

    mglnr = orchestra.member.mglnr

    if orchestra.report_sheet_for_year(year).nil? and orchestra.report_sheet_required?
      logger.debug("Skipping #{mglnr} - no report sheet")
      return 
    end

    Rails.logger.debug { "Generate invoice for: #{mglnr}" }
    invoice_pdf = orchestra_invoice(orchestra, year)

    if invoice_pdf.nil?
      logger.error("No invoice generated for mglnr: #{mglnr}")
      return
    else
      logger.debug("PDF File archived as #{invoice_pdf}")

      add_mailer_params = { year: year, mglnr: mglnr }

      tool.deliver_mailing(InvoiceMail, orchestra.to_addressee, invoice_pdf, nil, letters, add_mailer_params)
    end

    sepa_file = sepa_writer.generate_file 
    send_single_pdf_mail(invoice_pdf, sepa_file, mglnr: mglnr, letter: letters.length>0)
  end


  private
  def orchestra_invoice(orch, year)
    invoice = orch.gen_invoice(year)

    if not invoice.present?
      logger.error("could not generate invoice data")
      return nil
    end

    invoice.generator_session_id = generator_session_id
    invoice.save

    invoice_pdf = invoice.gen_pdf(pdf_writer)

    if not invoice_pdf.present?
      logger.error("Could not generate invoice PDF")
      return nil 
    end

    booking_txt = "Beitrag #{String(year)}"
    orch.member.create_invoice_booking(year, invoice, invoice_pdf.orig_filename, booking_txt)
    orch.member.create_dd_booking(sepa_writer, invoice, year)

    invoice_pdf
  end

  def send_single_pdf_mail(invoice, sepa, mglnr:, letter:)
    invoice_url = dl_url_for_file(invoice)
    sepa_url = dl_url_for_file(sepa)
    sepa_invoices_url = dl_sepa_invoices_url(generator_session_id: generator_session_id)

    User.for_admin_notify.each do |user|
      AdminNotifier.single_invoice(user, invoice_url, sepa_url: sepa_url, sepa_invoices_url: sepa_invoices_url, mglnr: mglnr, letter: letter, triggered_by: triggered_by ).deliver

    end
  end 
end
