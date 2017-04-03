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

    init_fields(year,user_id)

    invoices = Array.new
    letters = Array.new

	  @orchestras = Orchestra.notinvoiced(year).where("NOT orch_type='L'")

    tool =  MailingTool.new(year, "gs", "RECHNUNG#{year}", "Beitragsrechnung #{year}")

	  @orchestras.each do |orch|
      mglnr = orch.member.mglnr
      Rails.logger.debug("Gen invoice for: #{mglnr}")
      invoice_file = orchestraInvoice(orch,year,self.tex_writer,self.sepa_writer)
      logger.debug("PDF File archived as #{invoice_file}")

      add_mailer_params = { :year => year, :mglnr=>mglnr }

      tool.deliver_mailing(InvoiceMail, orch.to_addressee, invoice_file,nil, letters, add_mailer_params)  
		end

    pdf_merged_file = nil

    if letters.size > 0 then
      pdf_filename = "#{self.date_prefix}-orch-beitragsrechnungen.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)
      merge_pdfs(letters, pdf_merged_file)
    end

    ddFile = self.sepa_writer.generateFile

    send_mail(ddFile, pdf_merged_file,self.triggered_by)
  end

  def orchestraInvoice(orch, year)

		sheet = orch.sheet_for_year(year)

    if sheet.nil? then
      Rails.logger.info("No Sheet for orchestra #{orch} and year#{year}")
      return
    end

    invoice = sheet.gen_invoice
    invoice.generator_session_id = self.generator_session_id
    invoice.save

    invoice_file = invoice.gen_pdf(self.tex_writer)

		booking_txt = 'Beitrag '+String(year)
    create_invoice_booking(person, year, invoice, invoice_file.orig_filename,booking_txt)
    create_dd_booking(orch, invoice, year)

    invoice_file
  end
end
