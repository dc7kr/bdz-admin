class EventCardInvoiceMailsJob < BaseInvoicesJob

  include BulkMailHelper
  include Rails.application.routes.url_helpers

  include PdfHelper
  include UploadHelper
  include FestivalMailsHelper

  def perform(user_id, event_id)

    successCount=0
    failCount=0
    results = Hash.new

    cur_year = Time.now.year

    results = Array.new

    applicants = nil

    tool = MailingTool.new(cur_year.to_s,"gs",event_id,"Festival Ticket Rechnung",false);
    
    fa = FileArchiveTool.new(DOCS_CONFIG)

    letterArray = Array.new

    tw = TexWriter.new

    prefix = Time.now.strftime("%Y%m%d%H%M%S_")

    reservation = EventCard.not_invoiced

    reservation.each do |rsrv|

      invoice = rsrv.invoice 

      if ( invoice.sum <= 0) then
        Rails.logger.info("Skipped invoice for TLN #{invoice.customer.id} because of zero or negative invoice.")
      else
        tw.writeInvoice(invoice,'festival',cur_year)

        inv_type = "event_card.en"
        locale = :en
        subject = "eurofestival zupfmusik #{BDZ_SETTINGS["config"]["festival_year"]} ticket invoice no. #{invoice.number} for reservation no. #{rsrv.id}"

        if invoice.customer.preferred_lang == 'de' then
          inv_type = "event_card.de"
          subject = "eurofestival zupfmusik #{BDZ_SETTINGS["config"]["festival_year"]} - Ticket Rechnung Nr. #{invoice.number} fuer Reservierung Nr. #{rsrv.id}"
          locale = :de
        end

        work_pdf_file = tw.gen_pdf(inv_type,prefix,invoice.customer.id)

        workdir = INVOICE_CONFIG.work_dir
        invoice_file = fa.archive_file(workdir,work_pdf_file,cur_year)  

        mailer_params = { :subject => subject , :cc => BDZ_SETTINGS["contacts"]["treasurer"]["mail"], :bcc => "webmaster@bdz-online.de", :invoice => invoice, :locale => locale }

        result = tool.deliver_mailing(EventCardInvoiceMail, rsrv.to_addressee, invoice_file,  nil, letterArray, mailer_params)  
        results << result

        if result[:success]==true then
            successCount+=1;
            rsrv.invoiced=true
            rsrv.save
        else 
            failCount+=1;
        end
      end
    end
  end
end
