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

    EventCardInvoiceMailsWorker.perform_async(@current_user.id, 'ECINVOICE')

    respond_to do |format|
      format.html { redirect_to home_festival_data_path, notice: t('festival_mail.reservation_invoice_success') }
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

    FestivalInvoiceMailsWorker.perform_async(@current_user.id, 'TLNINVOICE')

    respond_to do |format|
      format.html { redirect_to home_festival_data_path, notice: t('festival_mail.invoice_success') }
    end
  end

  def send_mails
    authorize! :member, :edit

    mail_params = params['festival_mail']

    FestivalMailsJob.perform_later(current_user.id, mail_params)

    respond_to do |format|
      format.html { redirect_to home_festival_data_path, notice: t('festival_mail.mails_success') }
    end
  end
end
