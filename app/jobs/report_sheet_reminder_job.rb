class ReportSheetReminderJob < ApplicationJob
  def perform
    fa = FileArchiveTool.new(DOCS_CONFIG)

    datePrefix = Time.zone.now.strftime("%Y%m%d_")
    year = Time.zone.now.strftime("%Y")

    orchestras = Orchestra.no_report_sheet(Time.zone.now.year)

    @tw = TexWriter.new
    pdfs = []

    tmpdir = DOCS_CONFIG.work_dir

    tool_dir = INVOICE_CONFIG.tool_dir

    orchestras.each do |orch|
      @tw.writeReportSheetReminderData(orch.to_customer)
      filename = `#{tool_dir}/bin/create_pdf.sh #{orch.member.mglnr} mahnung-meldebogen`
      filename = filename.chomp

      fa.archive_file(tmpdir, filename, year)
      pdfs << filename
    end

    pdf_filename = "#{datePrefix}mahnungen-meldebogen.pdf"
    pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
    fa.merge_pdfs(pdfs, pdf_merged_file)

    send_mail(pdf_filename)
  end
end
