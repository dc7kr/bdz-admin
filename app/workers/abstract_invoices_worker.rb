require 'tex_writer'
require 'sepa_writer'
require 'dtaus_writer'
require 'invoice_helper'
require 'fileutils.rb'
  
class AbstractInvoicesWorker 

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

  def gen_dd_booking(member, sw, invoice, year)

    booking_txt = "Rechnung Nr. #{invoice.invoice_number} #{member.mglnr}"
		if (member.is_direct_debit?) then
			sw.addBooking(member,invoice.sum,booking_txt,"RCUR")
			booking = MemberAccountBooking.newWithdrawal("Lastschrift "+booking_txt,invoice.sum)
			booking.member_id = member.id
			booking.save
    end
  end

  def send_mail(ddFile,letterFile,triggered_by)

    year = Time.now.strftime('%Y')
    pdf_prefix= Time.now.strftime '%Y%m%d'

    users = User.where("role like ? or role like ?", "%accounting%", "%admin%")

    base_url = cron_downloads_url
    invoices_url = base_url+"?year="+year+"&filename="+letterFile.orig_filename
    dd_url=nil

    if ( ddFile != nil ) then
      dd_url = base_url+"?year="+year+"&filename="+ddFile.orig_filename
    end

    users.each do |user| 
		  AdminNotifier.newinvoices_notification(user, invoices_url, dd_url,triggered_by).deliver
   		logger.info 'sent to %s' % user.email
	  end
  end
end
