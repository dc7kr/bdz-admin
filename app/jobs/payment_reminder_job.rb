class PaymentReminderJob < ApplicationJob
  def perform
    fa = FileArchiveTool.new(DOCS_CONFIG)

    datePrefix = Time.zone.now.strftime('%Y%m%d_')
    year = Time.zone.now.strftime('%Y')

    pm_data = PersonMember.no_payment
    orch_data = Orchestra.no_payment

    persons = pm_data[:members]
    orchestras = orch_data[:members]

    pdfs = []
    tmpdir = DOCS_CONFIG.work_dir

    tool_dir = INVOICE_CONFIG.tool_dir

    @tw = TexWriter.new
    orchestras.each do |orch_member|
      filtered_bookings = orch_member.get_unbalanced_bookings
      customer = orch_member.member_entity.to_customer
      @tw.writeReminderData(customer, filtered_bookings)
      filename = `#{tool_dir}/bin/create_pdf.sh #{orch_member.mglnr} mahnung-beitrag`
      filename = filename.chomp
      fa.archive_file(tmpdir, filename, year)
      pdfs << filename
    end

    persons.each do |person_member|
      filtered_bookings = person_member.get_unbalanced_bookings
      customer = person_member.member_entity.to_customer
      @tw.writeReminderData(customer, filtered_bookings)
      filename = `#{tool_dir}/bin/create_pdf.sh #{customer.id} mahnung-beitrag`
      filename = filename.chomp
      fa.archive_file(tmpdir, filename, year)
      pdfs << filename
    end

    pdf_filename = "#{datePrefix}mahnungen-beitrag.pdf"
    pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, year.to_s)
    merge_pdfs(pdfs, pdf_merged_file)

    send_mail(pdf_filename)
  end
end
