class FestivalFeeInvoiceMailsJob < BaseInvoicesJob
  include BulkMailHelper
  include Rails.application.routes.url_helpers

  include PdfHelper
  include UploadHelper
  include FestivalMailsHelper

  def perform(_user_id)
    successCount = 0
    failCount = 0


    festival_year = BDZ_SETTINGS["config"]["festival_year"]
    cur_year = Time.zone.now.year
    
    event_id = "FEE_INV_#{festival_year}"

    results = []

    tool = MailingTool.new(cur_year.to_s, "gs", event_id, "Festival Gebuehr Rechnung", false)

    letterArray = []

    Time.zone.now.strftime("%Y%m%d%H%M%S_")

    applicants = FestivalApplication.current_festival.regular.where("fee_invoice_id IS NULL").order(:id)

    applicants.each do |appl|
      invoice = appl.get_fee_invoice

      if invoice.sum <= 0
        Rails.logger.info("Skipped invoice for TLN #{invoice.customer.id} because of zero or negative invoice.")
        next
      end

      if not appl.needs_fee_invoice?
        Rails.logger.warn("BUG: Festival application #{appl.id} should not need fee invoice")
        next
      end

      locale = invoice.locale

      subject = "BDZ eurofestival zupfmusik #{festival_year} invoice no. #{invoice.full_number} for participant no. #{appl.id}"

      if (invoice.locale == "de") 
        subject = "BDZ eurofestival zupfmusik #{festival_year} - Rechnung Nr. #{invoice.full_number} fuer Teilnehmer Nr. #{appl.id}"
      end

      I18n.locale = invoice.locale
      invoice_file = invoice.gen_pdf

      if invoice_file.nil?
        Rails.logger.warning("Invoice file was nil for applicant #{appl.id}")
        next
      end

      appl.fee_invoice_id = invoice.id
      appl.save

      Rails.logger.debug("deliver invoice #{appl.fee_invoice_id} to applicant # #{appl.id}")

      contact = appl.contact_person

      mailer_params = { subject: subject, 
                        invoice_id: appl.fee_invoice_id, 
                        locale: locale }

      result = tool.deliver_mailing(FestivalInvoiceMail, contact.to_addressee, invoice_file, nil, letterArray, mailer_params)
      results << result

      if result[:success] == true
        successCount += 1
      else
        failCount += 1
      end
    end
  end
end
