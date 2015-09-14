require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
class Cron::RemindersController < AuthenticatedNonResourceController

  include FileArchiveHelper

  def report_sheet
  	authorize! :member, :edit

    datePrefix = Time.now.strftime("%Y%m%d_")
    year = Time.now.strftime("%Y")

    @orchestras = Orchestra.includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.member_id AND report_sheets.year='+String(Time.now.year)).where(['report_sheets.id IS NULL'])

    @tw = TexWriter.new 
    pdfs = Array.new

    tmpdir = BDZ_SETTINGS["docs_work_dir"]

    @orchestras.each do |orch|
      @tw.writeReportSheetReminderData(orch)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{orch.mglnr} mahnung-meldebogen`
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

    @ids = MemberAccountBooking.unbalanced_for

    @persons = PersonMember.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])
    @orchestras = Orchestra.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

    pdfs = Array.new
    tmpdir = BDZ_SETTINGS["docs_work_dir"]

    @tw = TexWriter.new 
    @orchestras.each do |orch|
      
		  filtered_bookings = orch.get_unbalanced_bookings
     
      @tw.writeReminderData(orch,filtered_bookings)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{orch.mglnr} mahnung-beitrag`
      filename = filename.chomp
      out_file = archive_file(tmpdir,filename, year);
      pdfs << filename
    end

    @persons.each do |person|
		  filtered_bookings = person.get_unbalanced_bookings
      @tw.writeReminderData(person,filtered_bookings)
      filename = `/opt/bdz-rechnung/bin/create_pdf.sh #{person.mglnr} mahnung-beitrag`
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

    @users = User.with_any_role(:admin, :gs)
    base_url = cron_downloads_url
	  reminders_url = base_url+"?year="+year+"&filename="+pdf_file
	  @users.each do |user| 
		  AdminNotifier.newreminders_notification(user, reminders_url, current_user).deliver
	  end
  end
end

