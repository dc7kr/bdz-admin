class GenerateParticipantTicketInvoicesJob < BaseInvoicesJob
  include BulkMailHelper
  include Rails.application.routes.url_helpers

  include PdfHelper
  include UploadHelper
  include FestivalMailsHelper

  def perform

    festival_year = BDZ_SETTINGS["config"]["festival_year"]
    event_id = "TICKET_INV_#{festival_year}"

    cur_year = Time.zone.now.year
    ts = Time.zone.now.strftime("%Y%m%d%H%M%S_")

    participants = FestivalApplication.current_with_contacts.regular.where("ticket_invoice_id IS NULL").order(:id)

    participants.each do |part|
      if part.has_ticket_invoice?
        next
      end

      invoice = part.get_ticket_invoice

      if invoice.sum <= 0
        Rails.logger.info("Skipped invoice for TLN #{invoice.customer.id} because of zero or negative invoice.")
      else

        invoice_file = invoice.gen_pdf(pdf_writer)
        invoice.save
        part.ticket_invoice_id = invoice.id
        part.save

        ParticipantTicketInvoiceMailer.notification(part.token).deliver
      end
    end
  end
end
