require "fileutils"

class BaseInvoicesJob < ApplicationJob
  attr_accessor :generator_session_id, :date_prefix, :pdf_writer, :sepa_writer, :triggered_by, :archive_tool

  include BulkMailHelper
  include Rails.application.routes.url_helpers

  # sidekiq_options queue: "high"
  sidekiq_options retry: false

  def default_url_options
    {
      host: ActionMailer::Base.default_url_options[:host],
      protocol: ActionMailer::Base.default_url_options[:protocol]
    }
  end

  def init_fields(user_id)
    self.generator_session_id = SecureRandom.uuid
    self.date_prefix = Time.zone.now.strftime "%Y%m%d%H%M%S"

    self.sepa_writer = CorikaInvoices::SepaWriter.new(date_prefix, INVOICE_CONFIG)

    self.archive_tool = FileArchiveTool.new(DOCS_CONFIG)

    self.triggered_by = if user_id.nil?
      nil
    else
      User.find(user_id)
    end
  end

  def send_mail(sepa_file, letter_file, generator_session_id=nil)
    url_helpers = Rails.application.routes.url_helpers

    sepa_url = dl_url_for_file(sepa_file)
    invoices_url = dl_url_for_file(letter_file)
    sepa_invoices_url = url_helpers.dl_combined_invoice_url(generator_session_id: generator_session_id) unless generator_session_id.nil?

    User.for_admin_notify.each do |user|
      AdminNotifier.new_invoices(user, invoices_url: invoices_url, sepa_url: sepa_url, sepa_invoices_url: sepa_invoices_url).deliver
    end
  end

  private
  def dl_url_for_file(file)
    url_helpers = Rails.application.routes.url_helpers

    url = nil

    if file.nil?
      Rails.logger.warning("Download URL file is nil")
      return nil
    end

    url = url_helpers.dl_url(year: file.archive_folder, filename: file.orig_filename) unless file.nil?

    url
  end
end
