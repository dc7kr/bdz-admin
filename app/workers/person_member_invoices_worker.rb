
class PersonMemberInvoicesWorker  < AbstractInvoicesWorker

  def perform(year,user_id)

	  tw = TexWriter.new
    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    sw = SEPAWriter.new(datePrefix, BDZ_SETTINGS)
    invoices = Array.new
    letters = Array.new
    triggered_by = User.find(user_id)

    @person_members = PersonMember.includes([:tariff,:member]).joins("LEFT JOIN member_account_bookings mb ON person_members.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = #{year}" ).where("mb.id IS NULL").order("members.mglnr")

    tool =  MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

	  @person_members.each do |pm|
      Rails.logger.debug("Gen invoice for: #{pm.mglnr}")
      invoice_file = personMemberInvoice(datePrefix, pm,year,tw,sw)

      if (invoice_file.nil?) then
        Rails.logger.info("No invoice generated for: #{pm.mglnr} tariff: #{pm.tariff.description}")
        next
      end

      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { :year => year, :mglnr=>pm.mglnr }

      tool.deliver_mailing(InvoiceMail, pm, invoice_file,nil, letters, add_mailer_params)  
		end

    pdf_filename = "#{datePrefix}-em-beitragsrechnungen.pdf"

    pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)

    merge_pdfs(letters, pdf_merged_file)

    ddFile = sw.generateFile

    send_mail(ddFile, pdf_merged_file,triggered_by)
  end

  private 
  def personMemberInvoice(datePrefix, person,year,tw,sw)

      if ( person.tariff.amount == 0 )
        return
      end

    invoice_type = "beitragsrechnung"

    invoice = person.gen_invoice(year)

		tw.writeInvoice(invoice, 'gs',year)

    work_pdf_file = tw.gen_pdf(invoice_type,datePrefix, person.mglnr)

    workdir = BDZ_SETTINGS["invoice_workdir"]
    invoice_file = archive_file(workdir,work_pdf_file,year)

		booking_txt = 'Beitrag '+person.tariff.description+' '+String(year)
		booking = MemberAccountBooking.newInvoice(booking_txt,-1*invoice.sum,person.mglnr.to_s)
		booking.member_id = person.id
    booking.booking_year=year
    booking.filename = invoice_file.orig_filename
		booking.save

    gen_dd_booking(sw, person, invoice, year)

    invoice_file
  end
end
