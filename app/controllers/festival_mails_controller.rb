class FestivalMailsController < AuthenticatedNonResourceController
  include BulkMailHelper
  include UploadHelper
  include FestivalMailsHelper

  def index
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end

  def reservation_invoices
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end

  def send_reservation_invoices
    authorize! :member, :edit

    EventCardInvoiceMailsWorker.perform_async(@current_user.id, "ECINVOICE")

    respond_to do |format|
      format.html { redirect_to home_landing_page_path, notice: t("festival_mail.reservation_invoice_success") }
    end
  end

  def invoices
    authorize! :member, :edit
    respond_to do |format|
      format.html
    end
  end

  def send_invoices
    authorize! :member, :edit

    FestivalInvoiceMailsWorker.perform_async(@current_user.id, "TLNINVOICE")

    respond_to do |format|
      format.html { redirect_to home_landing_page_path, notice: t("festival_mail.invoice_success") }
    end
  end

  def send_mails
    authorize! :member, :edit

    cur_year = Time.zone.now.strftime "%Y"

    job_params = mail_params

    datafile = mail_params[:datafile]

    if not datafile.nil?
      data_mailing_file = store_uploaded_file(cur_year.to_s, datafile.original_filename, datafile) unless datafile.nil?
      job_params[:datafile] = data_mailing_file.to_hash
    end

    FestivalMailsJob.perform_later(current_user.id, job_params)

    respond_to do |format|
      format.html { redirect_to home_landing_page_path, notice: t("festival_mail.mails_success") }
    end
  end

  def mail_params
    params.require("festival_mail").permit(:event_id, :group, :subject, :body, :datafile)
  end
end
