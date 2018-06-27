require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
require 'fileutils.rb'
  
class AbstractInvoicesWorker 

  attr_accessor :generator_session_id,:date_prefix,:tex_writer,:sepa_writer,:triggered_by

  
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

  def init_fields(year,user_id)
    self.generator_session_id = SecureRandom.uuid
    self.date_prefix = Time.now.strftime '%Y%m%d%H%M%S'

	  self.tex_writer = CorikaInvoices::TexWriter.new(INVOICE_CONFIG)
    self.sepa_writer = CorikaInvoices::SEPAWriter.new(self.date_prefix, INVOICE_CONFIG)
    self.triggered_by = User.find(user_id)
  end



  def send_mail(ddFile,letterFile,triggered_by)

    base_url = cron_downloads_url
    dd_url=nil
    invoices_url = nil

    if ( not letterFile.nil?) then
      invoices_url = "#{base_url}?year=#{letterFile.archive_folder}&filename=#{letterFile.orig_filename}"
    end

    if not ddFile.nil? then
      dd_url = "#{base_url}?year=#{ddFile.archive_folder}&filename=#{ddFile.orig_filename}"
    end

    User.for_admin_notify.each do |user|
      AdminNotifier.newinvoices_notification(user, invoices_url, dd_url,triggered_by).deliver
      logger.info 'Admin notify sent to %s' % user.email
    end
  end
end
