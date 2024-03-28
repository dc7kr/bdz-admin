class Cron::RemindersController < AuthenticatedNonResourceController

  include FileArchiveHelper

  def report_sheet
  	authorize! :member, :edit

    datePrefix = Time.now.strftime("%Y%m%d_")
    year = Time.now.strftime("%Y")

    @orchestras = Orchestra.no_report_sheet(Time.now.year)

    @tw = TexWriter.new 
    pdfs = Array.new

    tmpdir = DOCS_CONFIG.work_dir

    @orchestras.each do |orch|
      @tw.writeReportSheetReminderData(orch.to_customer)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{orch.member.mglnr} mahnung-meldebogen`
      filename = filename.chomp

      out_file = archive_file(tmpdir,filename, year);
      pdfs << filename
    end

    pdf_filename = "#{datePrefix}mahnungen-meldebogen.pdf"
    pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)
    merge_pdfs(pdfs, pdf_merged_file)

    send_mail(pdf_filename)

    render :text => " OK."
  end

  def payment
  	authorize! :member, :edit

    datePrefix = Time.now.strftime("%Y%m%d_")
    year = Time.now.strftime("%Y")

    min_age = Time.now - 30.days
    pm_data = PersonMember.no_payment
    orch_data = Orchestra.no_payment

    @persons = pm_data[:members]

    @orchestras = orch_data[:members]

    pdfs = Array.new
    tmpdir = DOCS_CONFIG.work_dir

    @tw = TexWriter.new 
    @orchestras.each do |orch_member|
      
		  filtered_bookings = orch_member.get_unbalanced_bookings
      customer = orch_member.member_entity.to_customer
      @tw.writeReminderData(customer,filtered_bookings)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{orch_member.mglnr} mahnung-beitrag`
      filename = filename.chomp
      out_file = archive_file(tmpdir,filename, year);
      pdfs << filename
    end

    @persons.each do |person_member|
		  filtered_bookings = person_member.get_unbalanced_bookings
      customer = person_member.member_entity.to_customer
      @tw.writeReminderData(customer,filtered_bookings)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{customer.id} mahnung-beitrag`
      filename = filename.chomp
      out_file = archive_file(tmpdir,filename, year);
      pdfs << filename
    end

    pdf_filename = "#{datePrefix}mahnungen-beitrag.pdf"
    pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,year.to_s)
    merge_pdfs(pdfs, pdf_merged_file)

    send_mail(pdf_filename)

    render :text => " OK."
  end

  def send_mail(pdf_file)
	  year = Time.now.strftime('%Y')
	  pdf_prefix= Time.now.strftime '%Y%m%d'

    @users = User.with_any_role(:admin, :bulk_notify)
    base_url = cron_downloads_url
	  reminders_url = base_url+"?year="+year+"&filename="+pdf_file
	  @users.each do |user| 
		  AdminNotifier.newreminders_notification(user, reminders_url, current_user).deliver
	  end
  end
end

