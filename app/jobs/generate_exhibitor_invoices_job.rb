class GenerateExhibitorInvoicesJob < BaseInvoicesJob
  queue_as :default
  sidekiq_options retry: false

  def perform
    init_fields(nil)

    exhibitors = FestivalExhibitor.current_festival

    exhibitors.each do |exhibitor|
      invoice = exhibitor.gen_invoice
      invoice.generator_session_id = self.generator_session_id
      invoice.save

      pdf = invoice.gen_pdf

      exhibitor.invoice_id = invoice.id.to_s
      exhibitor.save
      ExhibitorInvoiceMailer.customer_mail(invoice.id).deliver
    end

    User.for_admin_notify.each do |u|
      ExhibitorInvoiceMailer.admin_mail(u.email, self.generator_session_id).deliver
    end
  end
end

