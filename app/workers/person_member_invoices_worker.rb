
class PersonMemberInvoicesWorker  < AbstractInvoicesWorker
 
   
  def perform(year,user_id)
    init_fields(year,user_id)

    invoices = Array.new
    letters = Array.new

    person_members = PersonMember.notinvoiced(year)

    mailing_tool =  MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

	  person_members.each do |pm|
      mglnr = pm.member.mglnr

      Rails.logger.debug("Gen invoice for: #{pm.member.mglnr}")
      invoice_file = personMemberInvoice(pm, year,self.tex_writer,self.sepa_writer)

      if (invoice_file.nil?) then
        Rails.logger.info("No invoice generated for: #{mglnr} tariff: #{pm.tariff.description}")
        next
      end

      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { :year => year, :mglnr=>mglnr }

      mailing_tool.deliver_mailing(InvoiceMail, pm.to_addressee, invoice_file,nil, letters, add_mailer_params)  
		end

    pdf_filename = "#{self.date_prefix}-em-beitragsrechnungen.pdf"

    pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)

    merge_pdfs(letters, pdf_merged_file)

    ddFile = self.sepa_writer.generateFile

    send_mail(ddFile, pdf_merged_file,self.triggered_by)
  end

  def personMemberInvoice(person,year,self.tex_writer,self.sepa_writer)
    invoice = person.gen_invoice(year)
    invoice.generator_session_id = self.generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(self.tex_writer)

		booking_txt = 'Beitrag '+member_entity.tariff.description+' '+String(year)

    create_invoice_booking(person, year, invoice, invoice_file.orig_filename,booking_txt)
    create_dd_booking(self.sepa_writer, person, invoice, year)

    invoice_file
  end
end
