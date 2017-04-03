
class PersonMemberInvoicesWorker  < AbstractInvoicesWorker

  def perform(year,user_id)

	  tw = TexWriter.new
    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    sw = SEPAWriter.new(datePrefix, BDZ_SETTINGS)
    invoices = Array.new
    letters = Array.new
    triggered_by = User.find(user_id)

    person_members = PersonMember.notinvoiced(year)

    mailing_tool =  MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

	  person_members.each do |pm|
      mglnr = pm.member.mglnr

      Rails.logger.debug("Gen invoice for: #{pm.member.mglnr}")
      invoice_file = personMemberInvoice(datePrefix, pm, year,tw,sw)

      if (invoice_file.nil?) then
        Rails.logger.info("No invoice generated for: #{mglnr} tariff: #{pm.tariff.description}")
        next
      end

      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { :year => year, :mglnr=>mglnr }

      mailing_tool.deliver_mailing(InvoiceMail, pm.to_addressee, invoice_file,nil, letters, add_mailer_params)  
		end

    pdf_filename = "#{datePrefix}-em-beitragsrechnungen.pdf"

    pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)

    merge_pdfs(letters, pdf_merged_file)

    ddFile = sw.generateFile

    send_mail(ddFile, pdf_merged_file,triggered_by)
  end

  private 
  def create_invoice_booking(person, year, invoice, filename)
		booking_txt = 'Beitrag '+person.tariff.description+' '+String(year)

		booking = MemberAccountBooking.newInvoice(booking_txt,-1*invoice.sum,person.member.mglnr.to_s)
		booking.member_id = person.member.id
    booking.booking_year=year
    booking.filename = filename
		booking.save
  end

  def personMemberInvoice(datePrefix, person,year,tw,sw)
    invoice = person.gen_invoice(year)
    invoice.save

    invoice_file = invoice.gen_pdf(tw)

    create_invoice_booking(person, year, invoice, invoice_file.orig_filename)
    gen_dd_booking(sw, person, invoice, year)

    invoice_file
  end
end
