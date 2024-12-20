class FestivalInvoiceMailsJob

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

    letterArray = Array.new

    tw = CorikaInvoices::TexWriter.new(INVOICE_CONFIG)

    prefix = Time.now.strftime("%Y%m%d%H%M%S_")

    applicants = FestivalApplication.where("permission=1 AND payment_status='P' AND visitor_type='R'")

    applicants.each do |appl|

      invoice = appl.invoice 

      if ( invoice.sum <= 0) then
        Rails.logger.info("Skipped invoice for TLN #{invoice.customer.id} because of zero or negative invoice.")
      else

        locale = :en
        subject = "eurofestival zupfmusik 2018 ticket invoice no. #{invoice.number} for participant no. #{appl.id}"

        if invoice.customer.country == 'de' or invoice.customer.country=='at' then
          subject = "eurofestival zupfmusik 2018 - Ticket Rechnung Nr. #{invoice.number} fuer Teilnehmer Nr. #{appl.id}"
          locale = :de
        end

        invoice_file = invoice.gen_pdf(tw)

        contact = appl.contact_person

        mailer_params = { :subject => subject , :cc => BDZ_SETTINGS["contacts"]["treasurer"]["mail"], :bcc => "webmaster@bdz-online.de", :invoice => invoice, :locale => locale }

        result = tool.deliver_mailing(FestivalInvoiceMail, contact.to_addressee, invoice_file,  nil, letterArray, mailer_params)  
        results << result

        if result[:success]==true then
            successCount+=1;
        else 
            failCount+=1;
        end
      end
    end
  end
end
