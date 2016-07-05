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

  def gen_dd_booking(sw, member_entity, invoice, year)
    member = member_entity.member
    customer = member_entity.to_customer

    booking_txt = "Rechnung Nr. #{invoice.invoice_number} #{member.mglnr}"
		if (member.is_direct_debit?) then
			sw.addBooking(customer,invoice.sum,booking_txt,"RCUR")
			booking = MemberAccountBooking.newWithdrawal("Lastschrift "+booking_txt,invoice.sum)
			booking.member_id = member.id
      booking.booking_year = year
			booking.save
    end
  end

  def send_mail(ddFile,letterFile,triggered_by)

    pdf_prefix= Time.now.strftime '%Y%m%d'

    base_url = cron_downloads_url
    dd_url=nil
    invoices_url = nil

    if ( not letterFile.nil?) then
      invoices_url = "#{base_url}?year=#{letterFile.archive_folder}&filename=#{letterFile.orig_filename}"
    end

    if ( ddFile != nil ) then
      dd_url = "#{base_url}?year=#{ddFile.archive_folder}&filename=#{ddFile.orig_filename}"
    end

    User.for_admin_notify.each do |user|
      AdminNotifier.newinvoices_notification(user, invoices_url, dd_url,triggered_by).deliver
      logger.info 'sent to %s' % user.email
    end
  end
end
