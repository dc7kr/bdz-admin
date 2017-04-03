require 'tex_writer'
require 'sepa_writer'
require 'dtaus_writer'
require 'invoice_helper'
require 'fileutils.rb'

class OrchestraInvoicesWorker < AbstractInvoicesWorker
  include Sidekiq::Worker
  include BulkMailHelper
  include FileArchiveHelper
  include Rails.application.routes.url_helpers

  # sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def default_url_options
    {
      :host =>  ActionMailer::Base.default_url_options[:host],
      :protocol => ActionMailer::Base.default_url_options[:protocol]
    }
  end

  def perform(year,user_id)

	  tw = TexWriter.new
    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    sw = SEPAWriter.new(datePrefix, BDZ_SETTINGS)

    triggered_by = User.find(user_id)

	  @orchestras = Orchestra.notinvoiced(year).where("NOT orch_type='L'")

    invoices = Array.new

    letters = Array.new

    tool =  MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

	  @orchestras.each do |orch|
      mglnr = orch.member.mglnr
      Rails.logger.debug("Gen invoice for: #{mglnr}")
      invoice_file = orchestraInvoice(datePrefix, orch,year,tw,sw)
      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { :year => year, :mglnr=>mglnr }

      tool.deliver_mailing(InvoiceMail, orch.to_addressee, invoice_file,nil, letters, add_mailer_params)  
		end

    pdf_merged_file = nil

    if letters.size > 0 then
      pdf_filename = "#{datePrefix}-orch-beitragsrechnungen.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)
      merge_pdfs(letters, pdf_merged_file)
    end

    ddFile = sw.generateFile

#    tw.moveGeneratedFiles(sw.datePrefix)
    send_mail(ddFile, pdf_merged_file,triggered_by)
  end

  private
  def orchestraInvoice(datePrefix, orch, year, tw, sw)
		booking_txt = "BDZ-Beitrag "+String(year)

    mglnr = orch.member.mglnr

    invoice_type = "beitragsrechnung"

		sheet = orch.sheet_for_year(year)

    if sheet.nil? then
      Rails.logger.info("No Sheet for orchestra #{orch} and year#{year}")
      return
    end

    invoice = sheet.gen_invoice

    invoice.save

		tw.writeInvoice(invoice, 'gs',year)

    work_pdf_file = tw.gen_pdf(invoice_type,datePrefix, mglnr)

    workdir = BDZ_SETTINGS["invoice_workdir"]
    invoice_file = archive_file(workdir,work_pdf_file,year)

		booking = MemberAccountBooking.newInvoice(booking_txt,-1*invoice.sum,mglnr.to_s)
		booking.member_id = orch.member.id
    booking.booking_year=year
    booking.filename = invoice_file.orig_filename
		booking.save

    gen_dd_booking(sw, orch, invoice, year)

    invoice_file
  end
end

