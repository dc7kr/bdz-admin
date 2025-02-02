require 'fileutils'

class BaseInvoicesJob < ApplicationJob
  attr_accessor :generator_session_id, :date_prefix, :tex_writer, :sepa_writer, :triggered_by, :archive_tool

  include BulkMailHelper
  include Rails.application.routes.url_helpers

  # sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def default_url_options
    {
      host: ActionMailer::Base.default_url_options[:host],
      protocol: ActionMailer::Base.default_url_options[:protocol]
    }
  end

  def init_fields(_year, user_id)
    self.generator_session_id = SecureRandom.uuid
    self.date_prefix = Time.zone.now.strftime '%Y%m%d%H%M%S'

    self.tex_writer = CorikaInvoices::TexWriter.new(INVOICE_CONFIG)
    self.sepa_writer = CorikaInvoices::SepaWriter.new(date_prefix, INVOICE_CONFIG)

    self.archive_tool = FileArchiveTool.new(DOCS_CONFIG)

    self.triggered_by = if user_id.nil?
                          nil
                        else
                          User.find(user_id)
                        end
  end

  def send_mail(ddFile, letterFile)
    base_url = cron_downloads_url
    dd_url = nil
    invoices_url = nil

    invoices_url = "#{base_url}?year=#{letterFile.archive_folder}&filename=#{letterFile.orig_filename}" unless letterFile.nil?

    dd_url = "#{base_url}?year=#{ddFile.archive_folder}&filename=#{ddFile.orig_filename}" unless ddFile.nil?

    User.for_admin_notify.each do |user|
      AdminNotifier.newinvoices_notification(user, invoices_url, dd_url, triggered_by).deliver
      logger.info 'new invoice notify sent to %s' % user.email
    end
  end
end
