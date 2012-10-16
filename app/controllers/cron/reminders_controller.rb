require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
class Cron::RemindersController < AuthenticatedNonResourceController

  def report_sheet
  	authorize! :member, :edit
    @orchestras = Orchestra.includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.member_id AND report_sheets.year='+String(Time.now.year)).where(['report_sheets.id IS NULL'])

	@tw = TexWriter.new 
	@orchestras.each do |orch|
		@tw.writeReportSheetReminderData(orch)
		system("/opt/bdz-rechnung/bin/mahnung.meldebogen.sh "+String(orch.mglnr))
	end

	system("/opt/bdz-rechnung/bin/merge_pdfs.sh mahnung-meldebogen")

	render :text => " OK."
  end

 def payment
  	authorize! :member, :edit
    @accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)

    @ids = Set.new
    @accounts.each do |account|
      if (account[1]<0) then
        @ids.add(account[0])
      end
    end

    @persons = PersonMember.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])
	@orchestras = Orchestra.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

	@tw = TexWriter.new 
	@orchestras.each do |orch|
		@tw.writeReminderData(orch)
		system("/opt/bdz-rechnung/bin/mahnung.sh "+String(orch.mglnr))
	end
	@persons.each do |person|
		@tw.writeReminderData(person)
		system("/opt/bdz-rechnung/bin/mahnung.sh "+String(person.mglnr))
	end

	system("/opt/bdz-rechnung/bin/merge_pdfs.sh mahnung")

	send_mail

	render :text => " OK."
  end

  def send_mail()
	year = Time.now.strftime('%Y')
	pdf_prefix= Time.now.strftime '%Y%m%d'

	@users = User.where("role like ?", "%admin%")
    base_url = cron_downloads_url
	invoices_url = base_url+"?year="+year+"&filename="+pdf_prefix+"-rechnung_merge.pdf"
	dtaus_url = base_url+"?year="+year+"&filename="+dtausPrefix+"dtaus.zip"

	@users.each do |user| 
		InvoiceNotifier.newinvoices_notification(user, invoices_url, dtaus_url).deliver
   		puts 'sent to %s' % current_user.email
	end
  end

end

